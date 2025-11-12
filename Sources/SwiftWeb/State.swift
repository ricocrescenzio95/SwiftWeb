import Foundation
import SwiftHTML

@MainActor
public protocol ComponentNode: Node {
  func __bindStorage(with fiber: Fiber)
  
  @HTMLBuilder
  nonisolated var content: Content { get }
}

@attached(extension, conformances: ComponentNode, names: named(__bindStorage))
public macro Component() = #externalMacro(module: "SwiftHTMLMacros", type: "ComponentMacro")

final class StateBox {
  var fiber: Fiber?
  var stateName: String?
  var initialValue: Any
  var value: Any {
    get {
      fiber?.states[stateName ?? ""] ?? initialValue
    }
    set {
      fiber?.states[stateName ?? ""] = newValue
    }
  }
  public init(_ initialValue: Any) {
    self.initialValue = initialValue
  }
}

@propertyWrapper
public struct State<Value> {
  var box: StateBox

  public init(wrappedValue: Value) {
    box = .init(wrappedValue)
  }

  public var wrappedValue: Value {
    get { box.value as! Value }
    nonmutating set {
      if let fiber = box.fiber, let treeRenderer {
        box.value = newValue
        treeRenderer.render(from: fiber)
      } else {
        fatalError("Cannot mutate unmounted view state")
      }
    }
  }
  
  public var projectedValue: Binding<Value> {
    .init {
      wrappedValue
    } set: {
      wrappedValue = $0
    }
  }
}

@propertyWrapper
public struct Binding<Value> {
  let get: () -> Value
  let set: (Value) -> Void
  
  public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
    self.get = get
    self.set = set
  }
  
  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }
  
  public var projectedValue: Self {
    self
  }
}
