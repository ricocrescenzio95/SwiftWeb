@attached(extension, conformances: ComponentNode, names: named(__bindStorage))
public macro Component() = #externalMacro(module: "SwiftHTMLMacros", type: "ComponentMacro")

@attached(member, names: arbitrary)
@attached(extension, conformances: ComponentNode, WebPage, names: arbitrary, named(route), named(__bindStorage))
public macro Page(route: Route) = #externalMacro(module: "SwiftHTMLMacros", type: "PageMacro")

@attached(accessor)
@attached(peer, names: prefixed(_), prefixed(`$`))
public macro State() = #externalMacro(module: "SwiftHTMLMacros", type: "StateMacro")
