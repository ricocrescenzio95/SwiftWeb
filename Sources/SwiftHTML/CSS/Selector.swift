extension CSS {
  public struct Selector: Sendable, Hashable, Codable {
    public var selector: String
    public var body: Body
    
    public init(_ selector: String, _ properties: [Property]) {
      self.selector = selector
      self.body = .init(properties)
    }
    
    public init(_ selector: String, _ properties: Property...) {
      self.init(selector, properties)
    }
    
    public init(_ selector: String, @CSS.PropertyBuilder _ properties: () -> [CSS.Property]) {
      self.init(selector, properties())
    }
    
    public var css: String {
      """
      \(selector) {
        \(body.css)
      }
      """
    }
  }
}

extension String {
  public func css(@CSS.PropertyBuilder _ properties: () -> [CSS.Property]) -> CSS.Selector {
    .init(self, properties)
  }
}
