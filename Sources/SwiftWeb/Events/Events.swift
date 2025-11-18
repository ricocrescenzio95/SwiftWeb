import SwiftHTML
import JavaScriptKit

// MARK: - Base Event Protocol

public protocol DOMEvent<Target> {
  associatedtype Target: NativeElement

  var nativeEvent: JSValue { get }
  
  var target: Target.Element { get }
  var currentTarget: Target.Element { get }
  var bubbles: Bool { get }
  var cancelable: Bool { get }
  var defaultPrevented: Bool { get }
  var eventPhase: Int { get }
  var isTrusted: Bool { get }
  var timeStamp: Double { get }
  func preventDefault()
  func stopPropagation()
  var type: String { get }
}

extension DOMEvent {
  public var target: Target.Element { Target.makeNativeElement(from: nativeEvent.target) }
  public var currentTarget: Target.Element { Target.makeNativeElement(from: nativeEvent.currentTarget) }
  public var bubbles: Bool { nativeEvent.bubbles.boolean ?? false }
  public var cancelable: Bool { nativeEvent.cancelable.boolean ?? false }
  public var defaultPrevented: Bool { nativeEvent.defaultPrevented.boolean ?? false }
  public var eventPhase: Int { Int(nativeEvent.eventPhase.number ?? 0) }
  public var isTrusted: Bool { nativeEvent.isTrusted.boolean ?? false }
  public var timeStamp: Double { nativeEvent.timeStamp.number ?? 0 }
  public func preventDefault() { _ = nativeEvent.preventDefault() }
  public func stopPropagation() { _ = nativeEvent.stopPropagation() }
  public var type: String { nativeEvent.type.string ?? "" }
}

// MARK: - Event Wrappers (Semplificati)

/// Generic event - usato per la maggior parte degli eventi
public struct GenericEvent<Target: NativeElement>: DOMEvent {
  public let nativeEvent: JSValue
  
  init(_ nativeEvent: JSValue) {
    self.nativeEvent = nativeEvent
  }
}

/// Pointer/Mouse event - per eventi con coordinate e pulsanti
public struct PointerEvent<Target: NativeElement>: DOMEvent {
  public let nativeEvent: JSValue
  
  init(_ nativeEvent: JSValue) {
    self.nativeEvent = nativeEvent
  }
  
  // Coordinates
  public var clientX: Double { nativeEvent.clientX.number ?? 0 }
  public var clientY: Double { nativeEvent.clientY.number ?? 0 }
  public var pageX: Double { nativeEvent.pageX.number ?? 0 }
  public var pageY: Double { nativeEvent.pageY.number ?? 0 }
  public var offsetX: Double { nativeEvent.offsetX.number ?? 0 }
  public var offsetY: Double { nativeEvent.offsetY.number ?? 0 }
  
  // Button info
  public var button: Int { Int(nativeEvent.button.number ?? 0) }
  public var buttons: Int { Int(nativeEvent.buttons.number ?? 0) }
  
  // Modifiers
  public var altKey: Bool { nativeEvent.altKey.boolean ?? false }
  public var ctrlKey: Bool { nativeEvent.ctrlKey.boolean ?? false }
  public var metaKey: Bool { nativeEvent.metaKey.boolean ?? false }
  public var shiftKey: Bool { nativeEvent.shiftKey.boolean ?? false }
  
  // Pointer-specific
  public var pointerId: Int { Int(nativeEvent.pointerId.number ?? 0) }
  public var pointerType: String { nativeEvent.pointerType.string ?? "mouse" }
  public var pressure: Double { nativeEvent.pressure.number ?? 0 }
}

/// Keyboard event
public struct KeyboardEvent<Target: NativeElement>: DOMEvent {
  public let nativeEvent: JSValue
  
  init(_ nativeEvent: JSValue) {
    self.nativeEvent = nativeEvent
  }
  
  public var key: String { nativeEvent.key.string ?? "" }
  public var code: String { nativeEvent.code.string ?? "" }
  public var keyCode: Int { Int(nativeEvent.keyCode.number ?? 0) }
  
  public var altKey: Bool { nativeEvent.altKey.boolean ?? false }
  public var ctrlKey: Bool { nativeEvent.ctrlKey.boolean ?? false }
  public var metaKey: Bool { nativeEvent.metaKey.boolean ?? false }
  public var shiftKey: Bool { nativeEvent.shiftKey.boolean ?? false }
  
  public var `repeat`: Bool { nativeEvent.repeat.boolean ?? false }
  public var isComposing: Bool { nativeEvent.isComposing.boolean ?? false }
}

/// Input event (per form inputs)
public struct InputEvent<Target: NativeElement>: DOMEvent {
  public let nativeEvent: JSValue
  
  init(_ nativeEvent: JSValue) {
    self.nativeEvent = nativeEvent
  }
  
  public var data: String? { nativeEvent.data.string }
  public var inputType: String { nativeEvent.inputType.string ?? "" }
  public var isComposing: Bool { nativeEvent.isComposing.boolean ?? false }
}

// MARK: - HTML Event Structure

public struct HTMLEvent {
  public let key: String
  public let handler: (JSValue) -> Void
}

public struct EventNode<AttributesType, Content: Node>: Node {
  var events: [HTMLEvent]
  public var content: Content
}

public extension HTMLElement where AttributesType: NativeElement {
  
  // MARK: - Pointer Events
  
  func onPointerDown(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "pointerdown") { handler(PointerEvent($0)) }
  }

  func onPointerUp(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "pointerup") { handler(PointerEvent($0)) }
  }
  
  func onPointerMove(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "pointermove") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Click Events
  
  func onClick(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "click") { handler(PointerEvent($0)) }
  }
  
  func onClick(_ handler: @escaping () -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "click") { _ in handler() }
  }

  func onDoubleClick(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "dblclick") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Mouse Events
  
  func onMouseDown(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "mousedown") { handler(PointerEvent($0)) }
  }
  
  func onMouseUp(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "mouseup") { handler(PointerEvent($0)) }
  }
  
  func onMouseMove(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "mousemove") { handler(PointerEvent($0)) }
  }
  
  func onMouseEnter(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "mouseenter") { handler(PointerEvent($0)) }
  }
  
  func onMouseLeave(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "mouseleave") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Keyboard Events
  
  func onKeyDown(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "keydown") { handler(KeyboardEvent($0)) }
  }
  
  func onKeyUp(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "keyup") { handler(KeyboardEvent($0)) }
  }
  
  func onKeyPress(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "keypress") { handler(KeyboardEvent($0)) }
  }
  
  // MARK: - Input Events
  
  func onInput(_ handler: @escaping (InputEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "input") { handler(InputEvent($0)) }
  }
  
  func onChange(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "change") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Focus Events
  
  func onFocus(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "focus") { handler(GenericEvent($0)) }
  }
  
  func onBlur(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "blur") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Form Events
  
  func onSubmit(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "submit") { handler(GenericEvent($0)) }
  }
  
  // MARK: - UI Events

  func onScroll(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Self>  {
    makeEventNode(key: "scroll") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Helper (private)
  
  private func makeEventNode(
    key: String, handler: @escaping (JSValue) -> Void
  ) -> EventNode<AttributesType, Self> {
    EventNode(events: [.init(key: key, handler: handler)], content: self)
  }
}

// TODO: FIND A BETTER WAY TO AVOID DUPLICATING FUNCTIONS

public extension EventNode where AttributesType: NativeElement {
  
  // MARK: - Pointer Events
  
  func onPointerDown(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "pointerdown") { handler(PointerEvent($0)) }
  }

  func onPointerUp(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "pointerup") { handler(PointerEvent($0)) }
  }
  
  func onPointerMove(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "pointermove") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Click Events
  
  func onClick(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "click") { handler(PointerEvent($0)) }
  }
  
  func onClick(_ handler: @escaping () -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "click") { _ in handler() }
  }

  func onDoubleClick(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "dblclick") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Mouse Events
  
  func onMouseDown(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "mousedown") { handler(PointerEvent($0)) }
  }
  
  func onMouseUp(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "mouseup") { handler(PointerEvent($0)) }
  }
  
  func onMouseMove(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "mousemove") { handler(PointerEvent($0)) }
  }
  
  func onMouseEnter(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "mouseenter") { handler(PointerEvent($0)) }
  }
  
  func onMouseLeave(_ handler: @escaping (PointerEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "mouseleave") { handler(PointerEvent($0)) }
  }
  
  // MARK: - Keyboard Events
  
  func onKeyDown(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "keydown") { handler(KeyboardEvent($0)) }
  }
  
  func onKeyUp(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "keyup") { handler(KeyboardEvent($0)) }
  }
  
  func onKeyPress(_ handler: @escaping (KeyboardEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "keypress") { handler(KeyboardEvent($0)) }
  }
  
  // MARK: - Input Events
  
  func onInput(_ handler: @escaping (InputEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "input") { handler(InputEvent($0)) }
  }
  
  func onChange(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "change") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Focus Events
  
  func onFocus(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "focus") { handler(GenericEvent($0)) }
  }
  
  func onBlur(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "blur") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Form Events
  
  func onSubmit(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "submit") { handler(GenericEvent($0)) }
  }
  
  // MARK: - UI Events

  func onScroll(_ handler: @escaping (GenericEvent<AttributesType>) -> Void) -> EventNode<AttributesType, Content>  {
    makeEventNode(key: "scroll") { handler(GenericEvent($0)) }
  }
  
  // MARK: - Helper (private)
  
  private func makeEventNode(
    key: String, handler: @escaping (JSValue) -> Void
  ) -> EventNode<AttributesType, Content> {
    EventNode(events: events + [.init(key: key, handler: handler)], content: content)
  }
}
