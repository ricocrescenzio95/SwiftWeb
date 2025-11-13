@resultBuilder
public enum CSS {
  public static func buildExpression(_ expression: CSS.Selector) -> [CSS.Selector] {
    [expression]
  }
  public static func buildBlock(_ components: [CSS.Selector]...) -> [CSS.Selector] {
    components.flatMap(\.self)
  }
  public static func buildBlock(_ components: [CSS.Selector]) -> [CSS.Selector] {
    components
  }
  public static func buildArray(_ components: [CSS.Selector]) -> [CSS.Selector] {
    components
  }
  public static func buildOptional(_ component: [CSS.Selector]?) -> [CSS.Selector] {
    component ?? []
  }
  public static func buildEither(first component: [CSS.Selector]) -> [CSS.Selector] {
    component
  }
  public static func buildEither(second component: [CSS.Selector]) -> [CSS.Selector] {
    component
  }
}
