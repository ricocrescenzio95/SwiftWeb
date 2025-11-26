import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntaxMacros

struct ComponentMacro: ExtensionMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    // Validate that @Component is only applied to struct
    validateStructDeclarationAttribute(attribute: node, declaration: declaration, in: context)

    // Find all @State properties
    let members = declaration.memberBlock.members
    var stateProperties: [String] = []

    for member in members {
      guard let variable = member.decl.as(VariableDeclSyntax.self) else {
        continue
      }

      // Check if this variable has @State attribute
      let hasStateAttribute = variable.attributes.contains { attribute in
        guard case let .attribute(attr) = attribute else { return false }
        return attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "State"
      }

      if hasStateAttribute {
        // Extract the property name (this is the actual property, not _property)
        for binding in variable.bindings {
          if let pattern = binding.pattern.as(IdentifierPatternSyntax.self) {
            stateProperties.append(pattern.identifier.text)
          }
        }
      }
    }
    
    // Generate the __bindStorage method (always, even if no state properties)
    let bindStorageMethods: String
    if !stateProperties.isEmpty {
      let bindingStatements = stateProperties.map { propName in
        "bindable.bind(stateName: \"\(propName)\", to: _\(propName))"
      }.joined(separator: "\n    ")

      bindStorageMethods = """

          public func __bindStorage(with bindable: some StateBindable) {
            \(bindingStatements)
          }
        """
    } else {
      bindStorageMethods = """

          public func __bindStorage(with bindable: some StateBindable) {
          }
        """
    }

    return try [
      ExtensionDeclSyntax("""
extension \(type): @MainActor ComponentNode {\(raw: bindStorageMethods)
}
""")
    ]
  }
}

// MARK: - Diagnostics

enum ComponentMacroFixIt: FixItMessage {
  case changeToStruct

  var message: String {
    switch self {
    case .changeToStruct:
      return "Change to struct"
    }
  }

  var fixItID: MessageID {
    MessageID(domain: "SwiftHTMLMacros", id: "ComponentMacro.FixIt.\(self)")
  }
}
