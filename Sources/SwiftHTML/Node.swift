// MARK: - Result Builder

public protocol Node<Content> {
  associatedtype Content: Node
  
  @HTMLBuilder
  var content: Content { get }
}

package struct _EmptyNode: Node {
  package var content: some Node { "" }
}

public enum _EitherNode<First: Node, Second: Node>: Node {
  case first(First)
  case second(Second)
  
  public var content: some Node {
    switch self {
    case .first(let first): first.content
    case .second(let second): second.content
    }
  }
}

package struct _TupleNode<First: Node, Second: Node>: Node {
  package var first: First
  package var second: Second
  
  package var content: some Node {
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
  public static func buildBlock() -> some Node {
    _EmptyNode()
  }
  public static func buildBlock(_ component: some Node) -> some Node {
    component
  }
  public static func buildPartialBlock(first: some Node) -> some Node {
    first
  }
  public static func buildPartialBlock(accumulated: some Node, next: some Node) -> some Node {
    _TupleNode(first: accumulated, second: next)
  }
  public static func buildEither<First: Node, Second: Node>(first component: First) -> _EitherNode<First, Second> {
    .first(component)
  }
  public static func buildEither<First: Node, Second: Node>(second component: Second) -> _EitherNode<First, Second> {
    .second(component)
  }
  public static func buildOptional<Wrapped: Node>(_ component: Wrapped?) -> _EitherNode<Wrapped, some Node> {
    if let component {
      _EitherNode<Wrapped, _EmptyNode>.first(component)
    } else {
      _EitherNode<Wrapped, _EmptyNode>.second(_EmptyNode())
    }
  }
  public static func buildFinalResult(_ component: some Node) -> some Node {
    component
  }
}
