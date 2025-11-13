import SwiftHTML
import JavaScriptKit

// MARK: - Fiber Converter

/// Converts SwiftHTML Nodes into Fiber nodes
struct FiberConverter {

  // MARK: - Main Conversion

  func convert(_ node: some Node, lane: Lane = .defaultLane) -> Fiber? {
    if let convertible = node as? FiberConvertible {
      return convertible.convert(using: self, lane: lane)
    }

    if let component = node as? any ComponentNode {
      return convertComponent(component, lane: lane)
    }

    return convert(node.content, lane: lane)
  }

  // MARK: - HTML Elements

  func convert<Attrs, Content: Node>(
    _ element: HTMLElement<Attrs, Content>,
    lane: Lane
  ) -> Fiber? {
    let attrs = element.attributes.reduce(into: [:]) { dict, attr in
      dict[attr.key] = attr.value ?? ""
    }

    let fiber = Fiber(
      tag: .hostDOM,
      type: element.name,
      pendingProps: attrs
    )
    fiber.sourceNode = element
    fiber.lanes = lane

    // Convert children
    if let childFiber = convert(element.content, lane: lane) {
      fiber.child = childFiber
      childFiber.parent = fiber

      // Link siblings and set parents
      var current = childFiber
      while let next = current.sibling {
        next.parent = fiber
        current = next
      }
    }

    return fiber
  }

  // MARK: - Event Nodes

  func convert<Content: Node>(
    _ element: EventNode<Content>,
    lane: Lane
  ) -> Fiber? {
    guard let fiber = convert(element.content, lane: lane) else {
      return nil
    }

    // Attach events to the fiber
    for event in element.events {
      fiber.events[event.key] = event.handler
    }

    return fiber
  }

  // MARK: - Text Nodes

  func convert(_ text: String, lane: Lane) -> Fiber? {
    let fiber = Fiber(
      tag: .hostText,
      type: "#text",
      textContent: text
    )
    fiber.lanes = lane
    return fiber
  }

  // MARK: - Components

  func convertComponent(_ component: any ComponentNode, lane: Lane) -> Fiber? {
    let fiber = Fiber(
      tag: .component,
      type: "#component"
    )
    fiber.sourceNode = component
    fiber.lanes = lane

    // Bind component state to this fiber
    component.__bindStorage(with: fiber)

    // Convert component's content
    if let childFiber = convert(component.content, lane: lane) {
      fiber.child = childFiber
      childFiber.parent = fiber

      var current = childFiber
      while let next = current.sibling {
        next.parent = fiber
        current = next
      }
    }

    return fiber
  }

  // MARK: - Tuples

  func convert<First: Node, Second: Node>(
    _ tuple: _TupleNode<First, Second>,
    lane: Lane
  ) -> Fiber? {
    let first = convert(tuple.first, lane: lane)
    let second = convert(tuple.second, lane: lane)

    // Link as siblings - IMPORTANT: Find the LAST sibling in the first chain!
    if let f = first, let s = second {
      // Find the last sibling in the first chain
      var lastSibling = f
      while let next = lastSibling.sibling {
        lastSibling = next
      }
      // Link at the end of the chain
      lastSibling.sibling = s
    }

    return first
  }

  // MARK: - Either

  func convert<First: Node, Second: Node>(
    _ either: _EitherNode<First, Second>,
    lane: Lane
  ) -> Fiber? {
    switch either {
    case .first(let node):
      return convert(node, lane: lane)
    case .second(let node):
      return convert(node, lane: lane)
    }
  }

  // MARK: - ForEach

  func convert<Data: RandomAccessCollection, ID: Hashable, Content: Node>(
    _ forEach: ForEach<Data, ID, Content>,
    lane: Lane
  ) -> Fiber? {
    var firstFiber: Fiber?
    var lastFiber: Fiber?

    for element in forEach.data {
      let key = AnyHashable(forEach.id(element))
      let content = forEach.contents(element)

      guard let fiber = convert(content, lane: lane) else { continue }
      fiber.key = key

      if firstFiber == nil {
        firstFiber = fiber
      } else {
        lastFiber?.sibling = fiber
      }
      lastFiber = fiber
    }

    return firstFiber
  }
}

// MARK: - FiberConvertible Protocol

protocol FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber?
}

// MARK: - Extend Types with Fiber Support

extension HTMLElement: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension EventNode: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension String: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension _TupleNode: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension _EitherNode: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension ForEach: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    converter.convert(self, lane: lane)
  }
}

extension _EmptyNode: FiberConvertible {
  func convert(using converter: FiberConverter, lane: Lane) -> Fiber? {
    .init(tag: .hostText, type: "")
  }
}
