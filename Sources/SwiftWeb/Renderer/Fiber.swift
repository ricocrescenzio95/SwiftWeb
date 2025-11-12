import SwiftHTML
import JavaScriptKit

// MARK: - Type Aliases

typealias EventHandler = (sending JSValue) -> Void

// MARK: - Constants

extension Fiber {
  enum Tag {
    static let text = "#text"
    static let component = "#component"
  }
}

// MARK: - Fiber Node

public final class Fiber: CustomStringConvertible {
  // MARK: Node Properties

  let tag: String
  var key: AnyHashable?
  var attributes: [String: String]
  var textContent: String?
  var children: [Fiber] = []

  // MARK: Tree Structure

  weak var parent: Fiber?
  var domNode: JSObject?
  var events: [String: EventHandler] = [:]

  // MARK: Source Tracking

  /// Track what Node created this Fiber for re-rendering
  var sourceNode: (any Node)?
  var states: [String: Any] = [:]

  // MARK: Reconciliation

  var alternate: Fiber?
  var effectTag: EffectTag = .none
  var nextEffect: Fiber?
  var firstEffect: Fiber?
  var lastEffect: Fiber?

  // MARK: Initialization

  init(
    tag: String,
    key: AnyHashable? = nil,
    attributes: [String: String] = [:],
    textContent: String? = nil,
    events: [String: EventHandler] = [:],
    parent: Fiber? = nil
  ) {
    self.tag = tag
    self.key = key
    self.attributes = attributes
    self.textContent = textContent
    self.events = events
    self.parent = parent
  }

  // MARK: Helper Methods

  /// Check if this is a text node
  var isTextNode: Bool {
    tag == Tag.text
  }

  /// Check if this is a component wrapper
  var isComponent: Bool {
    tag == Tag.component
  }

  /// Add children to this fiber, setting their parent reference
  func addChildren(_ newChildren: [Fiber]) {
    children.reserveCapacity(children.count + newChildren.count)
    for child in newChildren {
      child.parent = self
    }
    children.append(contentsOf: newChildren)
  }
  
  public func _bind<T>(stateName: String, to state: State<T>) {
    state.box.stateName = stateName
    state.box.fiber = self

    if states[stateName] == nil {
      // Initialize with the state's initial value if not present
      states[stateName] = state.box.initialValue
    }
    // If states[stateName] exists, we keep it (preserving component state)
    // The State.wrappedValue getter will read from fiber.states correctly
  }
  
  // MARK: CustomStringConvertible

  public var description: String {
    buildDescription(prefix: "")
  }

  private func buildDescription(prefix: String) -> String {
    var lines: [String] = []

    // Build current node description
    if isTextNode {
      lines.append("\(prefix)(text: \"\(textContent ?? "")\")")
    } else {
      var nodeDesc = "\(prefix)\(tag)"
      if !attributes.isEmpty {
        let attrsString = attributes
          .sorted { $0.key < $1.key }
          .map { "\($0.key)=\"\($0.value)\"" }
          .joined(separator: " ")
        nodeDesc += " [\(attrsString)]"
      }
      lines.append(nodeDesc)
    }

    // Add children recursively
    let childPrefix = prefix.replacing("|_", with: "  ") + " |_"
    for child in children {
      lines.append(child.buildDescription(prefix: childPrefix))
    }

    return lines.joined(separator: "\n")
  }
}

// MARK: - Effect Tags

enum EffectTag {
  case none
  case placement    // New fiber needs to be added to DOM
  case update       // Fiber needs to update its properties
  case deletion     // Fiber needs to be removed from DOM
}


protocol FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber]
}

extension HTMLElement: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension EventNode: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension String: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension _EmptyNode: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension _TupleNode: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension _EitherNode: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension Optional: FiberConvertible where Wrapped: Node {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

extension ForEach: FiberConvertible {
  func convert(using converter: FiberConverter) -> [Fiber] {
    converter.convert(self)
  }
}

// MARK: - Fiber Converter

struct FiberConverter {
  // Shared empty dictionary to avoid allocations
  private static let emptyAttributes: [String: String] = [:]

  // MARK: - HTML Elements

  @inline(__always)
  func convert<AttributesType, Content: Node>(_ element: HTMLElement<AttributesType, Content>) -> [Fiber] {
    let attributes = element.attributes.isEmpty
      ? Self.emptyAttributes
      : element.attributes.reduce(
          into: [String: String](minimumCapacity: element.attributes.count)
        ) { dict, attr in
          dict[attr.key] = attr.value ?? ""
        }

    let fiber = Fiber(tag: element.name, attributes: attributes)
    fiber.sourceNode = element

    // Convert and add child content
    if let convertible = element.content as? FiberConvertible {
      let children = convertible.convert(using: self)
      fiber.addChildren(children)
    }

    return [fiber]
  }

  // MARK: - Event Nodes
  
  @inline(__always)
  func convert<Content: Node>(_ element: EventNode<Content>) -> [Fiber] {
    let fibers = convertToFibers(element.content)

    // Attach events to all resulting fibers
    for fiber in fibers {
      for event in element.events {
        fiber.events[event.key] = event.handler
      }
    }

    return fibers
  }

  // MARK: - Primitive Types

  @inline(__always)
  func convert(_ text: String) -> [Fiber] {
    [Fiber(tag: Fiber.Tag.text, textContent: text)]
  }

  @inline(__always)
  func convert(_ empty: _EmptyNode) -> [Fiber] {
    []
  }

  // MARK: - Conditional & Collection Types
  
  func convert<First: Node, Second: Node>(_ tuple: _TupleNode<First, Second>) -> [Fiber] {
    var result: [Fiber] = []
    result.append(contentsOf: convertToFibers(tuple.first))
    result.append(contentsOf: convertToFibers(tuple.second))
    return result
  }

  func convert<First: Node, Second: Node>(_ either: _EitherNode<First, Second>) -> [Fiber] {
    switch either {
    case .first(let first):
      return convertToFibers(first)
    case .second(let second):
      return convertToFibers(second)
    }
  }

  func convert<Wrapped: Node>(_ optional: Wrapped?) -> [Fiber] {
    guard let wrapped = optional else { return [] }
    return convertToFibers(wrapped)
  }
  
  // MARK: - Components

  func convert(_ element: some Node) -> [Fiber] {
    // Check if this is a FiberConvertible type
    if let convertible = element as? FiberConvertible {
      return convertible.convert(using: self)
    }

    // Check if this is a stateful component
    if let component = element as? any ComponentNode {
      return convertComponent(component, sourceNode: element)
    }

    // Fallback: unwrap content
    return convert(element.content)
  }

  private func convertComponent(_ component: some ComponentNode, sourceNode: some Node) -> [Fiber] {
    let fiber = Fiber(tag: Fiber.Tag.component, attributes: Self.emptyAttributes)
    component.__bindStorage(with: fiber)
    fiber.sourceNode = sourceNode

    // Convert component's content
    let children = convertToFibers(sourceNode.content)
    fiber.addChildren(children)

    return [fiber]
  }
  
  // MARK: - ForEach

  @inline(__always)
  func convert<Data: RandomAccessCollection, ID: Hashable, Content: Node>(
    _ forEach: ForEach<Data, ID, Content>
  ) -> [Fiber] {
    var result: [Fiber] = []
    result.reserveCapacity(forEach.data.count)

    for element in forEach.data {
      let key = AnyHashable(forEach.id(element))
      let content = forEach.contents(element)
      let fibers = convertToFibers(content)

      // Set the key on all top-level fibers for this item
      fibers.forEach { $0.key = key }

      result.append(contentsOf: fibers)
    }

    return result
  }

  // MARK: - Helper Methods

  /// Convert any Node to fibers, handling FiberConvertible protocol
  @inline(__always)
  private func convertToFibers(_ node: some Node) -> [Fiber] {
    if let convertible = node as? FiberConvertible {
      return convertible.convert(using: self)
    } else {
      // Call the generic convert method which checks for ComponentNode
      return convert(node)
    }
  }
}
