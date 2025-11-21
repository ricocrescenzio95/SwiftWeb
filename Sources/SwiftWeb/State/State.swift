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

final class StateBox {
  weak var fiber: Fiber?
  var stateName: String?
  var initialValue: Any
  var value: Any {
    get {
      fiber?.states[stateName ?? ""] ?? initialValue
    }
    set {
      guard let fiber, let renderer else {
        fatalError("Cannot mutate unmounted view state")
      }
      fiber.states[stateName ?? ""] = newValue
      renderer.scheduleStateUpdate(from: fiber)
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
  
  public var wrappedValue: Value {
    get { box.value as! Value }
    nonmutating set { box.value = newValue }
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
  
  public static func constant(_ value: Value) -> Self {
    .init(get: { value }, set: { _ in })
  }
}
