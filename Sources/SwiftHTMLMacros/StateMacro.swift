import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntaxMacros

struct StateMacro {}

// MARK: - Accessor Macro

extension StateMacro: AccessorMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {

    guard let varDecl = declaration.as(VariableDeclSyntax.self),
          let binding = varDecl.bindings.first,
          let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
      return []
    }

    // Validate that @State is only used inside @Component
    validateComponentContext(declaration: declaration, in: context)

    let propertyName = identifier.text
    let storageName = "_\(propertyName)"

    let getter: AccessorDeclSyntax =
      """
      get {
        \(raw: storageName).value
      }
      """

    let setter: AccessorDeclSyntax =
      """
      nonmutating set {
        \(raw: storageName).value = newValue
      }
      """

    return [getter, setter]
  }
}

// MARK: - Peer Macro

extension StateMacro: PeerMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    guard let varDecl = declaration.as(VariableDeclSyntax.self),
          let binding = varDecl.bindings.first,
          let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
      return []
    }

    let propertyName = identifier.text
    let storageName = "_\(propertyName)"
    let projectedName = "$\(propertyName)"
    let type = binding.typeAnnotation?.type
    let initializer = binding.initializer

    // @State requires explicit type annotation
    guard let type = type else {
      let diagnostic = Diagnostic(
        node: declaration,
        message: StateMacroDiagnostic.missingTypeAnnotation(propertyName: propertyName)
      )
      context.diagnose(diagnostic)
      return []
    }

    // Determine the initial value
    let initValue: String
    if let initializer = initializer {
      initValue = "\(initializer.value)"
    } else {
      // No initializer - must be an optional type, use nil
      initValue = "nil"
    }

    return [
      // Storage property: _propertyName
      """
      private var \(raw: storageName): State<\(type)> = State(wrappedValue: \(raw: initValue))
      """,
      // Projected value: $propertyName
      """
      var \(raw: projectedName): Binding<\(type)> {
        \(raw: storageName).projectedValue
      }
      """
    ]
  }
}

// MARK: - Validation

/// Validates that @State is only used inside a @Component
private func validateComponentContext(
  declaration: some DeclSyntaxProtocol,
  in context: some MacroExpansionContext
) {
  // Walk up the lexical context to find any parent type declaration
  for lexicalContext in context.lexicalContext {
    // Check for struct
    if let structDecl = lexicalContext.as(StructDeclSyntax.self) {
      let hasComponentAttribute = structDecl.attributes.contains { attribute in
        guard case let .attribute(attr) = attribute else { return false }
        return attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Component"
      }

      if !hasComponentAttribute {
        let diagnostic = Diagnostic(
          node: declaration,
          message: StateMacroDiagnostic.notInComponent(typeName: structDecl.name.text)
        )
        context.diagnose(diagnostic)
      }
      return
    }

    // Check for class
    if let classDecl = lexicalContext.as(ClassDeclSyntax.self) {
      let diagnostic = Diagnostic(
        node: declaration,
        message: StateMacroDiagnostic.notInComponent(typeName: classDecl.name.text)
      )
      context.diagnose(diagnostic)
      return
    }

    // Check for actor
    if let actorDecl = lexicalContext.as(ActorDeclSyntax.self) {
      let diagnostic = Diagnostic(
        node: declaration,
        message: StateMacroDiagnostic.notInComponent(typeName: actorDecl.name.text)
      )
      context.diagnose(diagnostic)
      return
    }

    // Check for enum
    if let enumDecl = lexicalContext.as(EnumDeclSyntax.self) {
      let diagnostic = Diagnostic(
        node: declaration,
        message: StateMacroDiagnostic.notInComponent(typeName: enumDecl.name.text)
      )
      context.diagnose(diagnostic)
      return
    }
  }
}

// MARK: - Diagnostics

enum StateMacroDiagnostic: DiagnosticMessage {
  case notInComponent(typeName: String)
  case missingTypeAnnotation(propertyName: String)

  var message: String {
    switch self {
    case .notInComponent(let typeName):
      return "@State can only be used inside a @Component struct. Add @Component to '\(typeName)'"
    case .missingTypeAnnotation(let propertyName):
      return "@State property '\(propertyName)' requires an explicit type annotation (e.g., var \(propertyName): Int = 0)"
    }
  }

  var diagnosticID: MessageID {
    MessageID(domain: "SwiftHTMLMacros", id: "StateMacro.\(self)")
  }

  var severity: DiagnosticSeverity {
    .error
  }
}

