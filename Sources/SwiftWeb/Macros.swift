@attached(extension, conformances: ComponentNode, names: named(__bindStorage))
public macro Component() = #externalMacro(module: "SwiftHTMLMacros", type: "ComponentMacro")

@attached(extension, conformances: ComponentNode, names: named(__bindStorage))
public macro Component(route: Route) = #externalMacro(module: "SwiftHTMLMacros", type: "ComponentMacro")

@attached(accessor)
@attached(peer, names: prefixed(_), prefixed(`$`))
public macro State() = #externalMacro(module: "SwiftHTMLMacros", type: "StateMacro")
