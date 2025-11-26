import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Macros: CompilerPlugin {
  var providingMacros: [Macro.Type] = [
    ComponentMacro.self,
    StateMacro.self,
    PageMacro.self
  ]
}
