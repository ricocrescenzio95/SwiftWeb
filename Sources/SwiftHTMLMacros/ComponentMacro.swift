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
        // Extract the property name
        for binding in variable.bindings {
          if let pattern = binding.pattern.as(IdentifierPatternSyntax.self) {
            stateProperties.append(pattern.identifier.text)
          }
        }
      }
    }
    
    // Generate the __bindStorage method (always, even if no state properties)
    let bindStorageMethod: String
    if !stateProperties.isEmpty {
      let bindingStatements = stateProperties.map { propName in
        "fiber._bind(stateName: \"\(propName)\", to: _\(propName))"
      }.joined(separator: "\n    ")
      
      bindStorageMethod = """
        
          func __bindStorage(with fiber: Fiber) {
            \(bindingStatements)
          }
        """
    } else {
      bindStorageMethod = """
        
          func __bindStorage(with fiber: Fiber) {
          }
        """
    }
    
    return try [
      ExtensionDeclSyntax("""
extension \(type): @MainActor ComponentNode {\(raw: bindStorageMethod)
}
""")
    ]
  }
}
