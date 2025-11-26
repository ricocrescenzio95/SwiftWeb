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
  public static func buildArray(_ components: [[CSS.Selector]]) -> [CSS.Selector] {
    components.flatMap(\.self)
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

extension CSS {
  @resultBuilder
  public enum PropertyBuilder {
    public static func buildExpression(_ expression: CSS.Property) -> [CSS.Property] {
      [expression]
    }
    public static func buildExpression(_ expression: [CSS.Property]) -> [CSS.Property] {
      expression
    }
    public static func buildBlock(_ components: [CSS.Property]...) -> [CSS.Property] {
      components.flatMap(\.self)
    }
    public static func buildBlock(_ components: [CSS.Property]) -> [CSS.Property] {
      components
    }
    public static func buildArray(_ components: [[CSS.Property]]) -> [CSS.Property] {
      components.flatMap(\.self)
    }
    public static func buildOptional(_ component: [CSS.Property]?) -> [CSS.Property] {
      component ?? []
    }
    public static func buildEither(first component: [CSS.Property]) -> [CSS.Property] {
      component
    }
    public static func buildEither(second component: [CSS.Property]) -> [CSS.Property] {
      component
    }
  }
}
