public struct Route: ExpressibleByStringInterpolation {
  public struct Param<T> {
    var name: StaticString
    var type: T.Type
    
    public init(name: StaticString, type: T.Type) {
      self.name = name
      self.type = type
    }
  }
  public var path: String
  public init(stringLiteral value: String) {
    path = value
  }
}

extension DefaultStringInterpolation {
  fileprivate mutating func appendInterpolation<T: CustomStringConvertible>(
    param: StaticString,
    _ type: T.Type = String.self
  ) {
    appendInterpolation("{\(param): \(type)}")
  }
}
