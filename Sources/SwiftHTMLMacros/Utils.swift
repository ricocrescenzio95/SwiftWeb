import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntaxMacros

/// Validates that @Component is only applied to structs
@discardableResult
func validateStructDeclarationAttribute(
  attribute: AttributeSyntax,
  declaration: some DeclSyntaxProtocol,
  in context: some MacroExpansionContext
) -> StructDeclSyntax? {
  // Check if it's a struct
  if let declaration = declaration.as(StructDeclSyntax.self) {
    // Valid - it's a struct
    return declaration
  }

  // Invalid - @Component applied to non-struct
  var fixIts: [FixIt] = []

  if let classDecl = declaration.as(ClassDeclSyntax.self) {
    let fixIt = FixIt(
      message: ComponentMacroFixIt.changeToStruct,
      changes: [
        .replace(
          oldNode: Syntax(classDecl.classKeyword),
          newNode: Syntax(TokenSyntax.keyword(.struct, trailingTrivia: classDecl.classKeyword.trailingTrivia))
        )
      ]
    )
    fixIts.append(fixIt)
  } else if let actorDecl = declaration.as(ActorDeclSyntax.self) {
    let fixIt = FixIt(
      message: ComponentMacroFixIt.changeToStruct,
      changes: [
        .replace(
          oldNode: Syntax(actorDecl.actorKeyword),
          newNode: Syntax(TokenSyntax.keyword(.struct, trailingTrivia: actorDecl.actorKeyword.trailingTrivia))
        )
      ]
    )
    fixIts.append(fixIt)
  } else if let enumDecl = declaration.as(EnumDeclSyntax.self) {
    let fixIt = FixIt(
      message: ComponentMacroFixIt.changeToStruct,
      changes: [
        .replace(
          oldNode: Syntax(enumDecl.enumKeyword),
          newNode: Syntax(TokenSyntax.keyword(.struct, trailingTrivia: enumDecl.enumKeyword.trailingTrivia))
        )
      ]
    )
    fixIts.append(fixIt)
  }

  let diagnostic = Diagnostic(
    node: declaration,
    message: ValidationError.notAStruct(name: attribute.attributeName),
    fixIts: fixIts
  )
  context.diagnose(diagnostic)
  return nil
}

enum ValidationError: DiagnosticMessage {
  case notAStruct(name: TypeSyntax)

  var message: String {
    switch self {
    case .notAStruct(let name):
      return "@\(name) can only be applied to struct declarations"
    }
  }

  var diagnosticID: MessageID {
    MessageID(domain: "SwiftHTMLMacros", id: "ComponentMacro.\(self)")
  }

  var severity: DiagnosticSeverity {
    .error
  }
}

