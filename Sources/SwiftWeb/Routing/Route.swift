import Foundation

public struct Route: Sendable, Hashable, Codable, ExpressibleByStringInterpolation {
  public protocol Param {
    init(string: String) throws
    var string: String { get }
  }
  
  var segments: [RouteStringInterpolation.Segment]
  public var path: String = ""
  
  public init(stringLiteral value: StaticString) {
    path = String(describing: value)
    segments = [.literal(path)]
  }
  
  public init(stringInterpolation: RouteStringInterpolation) {
    segments = stringInterpolation.segments
    path = stringInterpolation.segments.map(\.string).joined()
  }
  
  public func resolve(arguments: [String]) -> String {
    var args = Array(arguments.reversed())
    return segments
      .map { segment in
        switch segment {
        case .literal(let string): string
        case .param(let string): args.popLast() ?? string
        }
      }
      .joined()
  }
}

public struct RouteStringInterpolation: StringInterpolationProtocol {
  enum Segment: Sendable, Hashable, Codable {
    case literal(String)
    case param(String)
    
    var string: String {
      switch self {
      case .literal(let string), .param(let string): string
      }
    }
  }
  var segments: [Segment] = []
  
  public init(literalCapacity: Int, interpolationCount: Int) {
    // maybe optimize using literalCapacity and interpolationCount?
  }
  
  public mutating func appendLiteral(_ literal: StaticString) {
    segments.append(.literal("\(literal)"))
  }
  
  public mutating func appendInterpolation<P: Route.Param>(
    param name: StaticString,
    _ type: P.Type = String.self
  ) {
    segments.append(.param("{\(name)}"))
  }
}

extension String: Route.Param {
  public init(string: String) {
    self = string
  }
  public var string: String { self }
}

public enum RouteParamError: Error {
  case invalidInteger(String)
  case invalidDouble(String)
  case invalidFloat(String)
  case invalidBoolean(String)
  case invalidUUID(String)
  case invalidRawRepresentableConversion(String, type: Any.Type)
}

extension Route.Param where Self: LosslessStringConvertible {
  public var string: String { String(self) }
}

extension Int: Route.Param {
  public init(string: String) throws {
    guard let value = Int(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension Int8: Route.Param {
  public init(string: String) throws {
    guard let value = Int8(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension Int16: Route.Param {
  public init(string: String) throws {
    guard let value = Int16(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension Int32: Route.Param {
  public init(string: String) throws {
    guard let value = Int32(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension Int64: Route.Param {
  public init(string: String) throws {
    guard let value = Int64(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension UInt: Route.Param {
  public init(string: String) throws {
    guard let value = UInt(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension UInt8: Route.Param {
  public init(string: String) throws {
    guard let value = UInt8(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension UInt16: Route.Param {
  public init(string: String) throws {
    guard let value = UInt16(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension UInt32: Route.Param {
  public init(string: String) throws {
    guard let value = UInt32(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension UInt64: Route.Param {
  public init(string: String) throws {
    guard let value = UInt64(string) else {
      throw RouteParamError.invalidInteger(string)
    }
    self = value
  }
}

extension Double: Route.Param {
  public init(string: String) throws {
    guard let value = Double(string) else {
      throw RouteParamError.invalidDouble(string)
    }
    self = value
  }
}

extension Float: Route.Param {
  public init(string: String) throws {
    guard let value = Float(string) else {
      throw RouteParamError.invalidFloat(string)
    }
    self = value
  }
}

extension Bool: Route.Param {
  public init(string: String) throws {
    let lowercased = string.lowercased()
    switch lowercased {
    case "true", "yes", "1":
      self = true
    case "false", "no", "0":
      self = false
    default:
      throw RouteParamError.invalidBoolean(string)
    }
  }
}

extension UUID: Route.Param {
  public init(string: String) throws {
    guard let value = UUID(uuidString: string) else {
      throw RouteParamError.invalidUUID(string)
    }
    self = value
  }
  public var string: String { uuidString }
}

extension RawRepresentable where RawValue: Route.Param {
  public init(string: String) throws {
    let param = try RawValue(string: string)
    if let value = Self(rawValue: param) {
      self = value
    } else {
      throw RouteParamError.invalidRawRepresentableConversion(string, type: Self.self)
    }
  }
  public var string: String { rawValue.string }
}
