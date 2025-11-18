// MARK: - Result Builder

public protocol Node<Content> {
  associatedtype Content: Node
  
  @HTMLBuilder
  var content: Content { get }
}

public struct EmptyNode: Node {
  public var content: some Node { "" }
  public init() {}
}

public enum EitherNode<First: Node, Second: Node>: Node {
  case first(First)
  case second(Second)
  
  public var content: some Node {
    switch self {
    case .first(let first): first.content
    case .second(let second): second.content
    }
  }
}

public struct TupleNode<First: Node, Second: Node>: Node {
  package var first: First
  package var second: Second
  
  public var content: some Node {
    first.content
    second.content
  }
}

extension String: Node {
  public var content: some Node { self }
}

extension Int: Node {
  public var content: some Node { String(self) }
}

extension Double: Node {
  public var content: some Node { String(self) }
}

extension Float: Node {
  public var content: some Node { String(self) }
}

extension Never: Node {
  public var content: some Node { fatalError("Never cannot be used") }
}

@resultBuilder
public struct HTMLBuilder {
  public static func buildBlock() -> EmptyNode {
    EmptyNode()
  }
  public static func buildBlock<N: Node>(_ component: N) -> N {
    component
  }
  public static func buildPartialBlock<N: Node>(first: N) -> N {
    first
  }
  public static func buildPartialBlock<Accumulated: Node, Next: Node>(accumulated: Accumulated, next: Next) -> TupleNode<Accumulated, Next> {
    .init(first: accumulated, second: next)
  }
  public static func buildEither<First: Node, Second: Node>(first component: First) -> EitherNode<First, Second> {
    .first(component)
  }
  public static func buildEither<First: Node, Second: Node>(second component: Second) -> EitherNode<First, Second> {
    .second(component)
  }
  public static func buildOptional<Wrapped: Node>(_ component: Wrapped?) -> EitherNode<Wrapped, EmptyNode> {
    if let component {
      .first(component)
    } else {
      .second(EmptyNode())
    }
  }
}
