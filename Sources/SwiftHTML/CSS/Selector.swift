extension CSS {
  public protocol Convertible {
    var cssValue: String { get }
  }
}

extension CSS {
  public struct Selector: Sendable, Hashable, Codable, Convertible {
    public var selector: String
    public var body: Body
    
    public init(_ selector: String, _ properties: [Property]) {
      self.selector = selector
      self.body = .init(properties)
    }
    
    public var cssValue: String {
      """
      \(selector) {
        \(body.cssValue)
      }
      """
    }
  }
}

extension String {
  public func callAsFunction(_ properties: CSS.Property...) -> CSS.Selector {
    .init(self, properties)
  }
  public func callAsFunction(_ properties: [CSS.Property]) -> CSS.Selector {
    .init(self, properties)
  }
}
