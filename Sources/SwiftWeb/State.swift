import Foundation
import SwiftHTML

public protocol ComponentNode: Node {
  func __bindStorage(with bindable: some StateBindable)

  @HTMLBuilder
  nonisolated var content: Content { get }
}

public protocol StateBindable {
  func bind<T>(stateName: String, to state: State<T>)
}

@attached(extension, conformances: ComponentNode, names: named(__bindStorage))
public macro Component() = #externalMacro(module: "SwiftHTMLMacros", type: "ComponentMacro")

@attached(accessor)
@attached(peer, names: prefixed(_), prefixed(`$`))
public macro State() = #externalMacro(module: "SwiftHTMLMacros", type: "StateMacro")

final class StateBox {
  weak var fiber: Fiber?
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

public struct State<Value> {
  var box: StateBox

  public init(wrappedValue: Value) {
    box = .init(wrappedValue)
  }
  
  public var value: Value {
    get { box.value as! Value }
    nonmutating set {
      guard let fiber = box.fiber, let renderer else {
        fatalError("Cannot mutate unmounted view state")
      }
      box.value = newValue
      renderer.scheduleStateUpdate(from: fiber)
    }
  }
  
  public var projectedValue: Binding<Value> {
    .init {
      value
    } set: {
      value = $0
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
