import SwiftHTML
import JavaScriptKit

// MARK: - Type-Safe Event Wrappers

/// Base protocol for all DOM events
public protocol DOMEvent {
  init(jsValue: JSValue)
}

/// Represents a PointerEvent from the DOM
public struct PointerEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("PointerEvent {")
    parts.append("  type: \(type)")
    parts.append("  pointerType: \(pointerType.rawValue)")
    parts.append("  pointerId: \(pointerId)")
    parts.append("  position: (\(clientX), \(clientY))")
    parts.append("  screen: (\(screenX), \(screenY))")
    parts.append("  page: (\(pageX), \(pageY))")
    parts.append("  offset: (\(offsetX), \(offsetY))")
    parts.append("  pressure: \(pressure)")
    parts.append("  tilt: (\(tiltX), \(tiltY))")
    parts.append("  twist: \(twist)")
    parts.append("  size: \(width)×\(height)")
    parts.append("  button: \(button)")
    parts.append("  buttons: \(buttons)")
    parts.append("  isPrimary: \(isPrimary)")
    
    var modifiers: [String] = []
    if altKey { modifiers.append("Alt") }
    if ctrlKey { modifiers.append("Ctrl") }
    if metaKey { modifiers.append("Meta") }
    if shiftKey { modifiers.append("Shift") }
    parts.append("  modifiers: \(modifiers.isEmpty ? "none" : modifiers.joined(separator: "+"))")
    
    parts.append("  timestamp: \(timeStamp)")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  // MARK: - Pointer-specific Properties
  
  /// Unique identifier for the pointer
  public var pointerId: Int {
    Int(jsValue.pointerId.number ?? 0)
  }
  
  /// Width of the contact geometry
  public var width: Double {
    jsValue.width.number ?? 0
  }
  
  /// Height of the contact geometry
  public var height: Double {
    jsValue.height.number ?? 0
  }
  
  /// Pressure normalized in the range [0,1]
  public var pressure: Double {
    jsValue.pressure.number ?? 0
  }
  
  /// Angle between Y-Z plane and pointer axis (-90 to 90)
  public var tiltX: Double {
    jsValue.tiltX.number ?? 0
  }
  
  /// Angle between X-Z plane and pointer axis (-90 to 90)
  public var tiltY: Double {
    jsValue.tiltY.number ?? 0
  }
  
  /// Clockwise rotation of pointer in degrees (0-359)
  public var twist: Double {
    jsValue.twist.number ?? 0
  }
  
  /// Tangential pressure (barrel pressure)
  public var tangentialPressure: Double {
    jsValue.tangentialPressure.number ?? 0
  }
  
  /// Type of pointer device
  public var pointerType: PointerType {
    guard let typeString = jsValue.pointerType.string else {
      return .unknown
    }
    return PointerType(rawValue: typeString) ?? .unknown
  }
  
  /// Whether this is the primary pointer
  public var isPrimary: Bool {
    jsValue.isPrimary.boolean ?? false
  }
  
  // MARK: - MouseEvent Properties (inherited)
  
  /// X coordinate relative to viewport
  public var clientX: Double {
    jsValue.clientX.number ?? 0
  }
  
  /// Y coordinate relative to viewport
  public var clientY: Double {
    jsValue.clientY.number ?? 0
  }
  
  /// X coordinate relative to screen
  public var screenX: Double {
    jsValue.screenX.number ?? 0
  }
  
  /// Y coordinate relative to screen
  public var screenY: Double {
    jsValue.screenY.number ?? 0
  }
  
  /// X coordinate relative to page
  public var pageX: Double {
    jsValue.pageX.number ?? 0
  }
  
  /// Y coordinate relative to page
  public var pageY: Double {
    jsValue.pageY.number ?? 0
  }
  
  /// X coordinate relative to target element
  public var offsetX: Double {
    jsValue.offsetX.number ?? 0
  }
  
  /// Y coordinate relative to target element
  public var offsetY: Double {
    jsValue.offsetY.number ?? 0
  }
  
  /// Mouse button that was pressed (0 = primary, 1 = auxiliary, 2 = secondary)
  public var button: Int {
    Int(jsValue.button.number ?? 0)
  }
  
  /// Bitmask of buttons currently pressed
  public var buttons: Int {
    Int(jsValue.buttons.number ?? 0)
  }
  
  // MARK: - UIEvent Properties
  
  /// Level of detail (e.g., click count)
  public var detail: Int {
    Int(jsValue.detail.number ?? 0)
  }
  
  // MARK: - Event Properties (base)
  
  /// Type of event (e.g., "click", "pointerdown")
  public var type: String {
    jsValue.type.string ?? ""
  }
  
  /// Event target element
  public var target: JSValue {
    jsValue.target
  }
  
  /// Current event target
  public var currentTarget: JSValue {
    jsValue.currentTarget
  }
  
  /// Timestamp when the event was created
  public var timeStamp: Double {
    jsValue.timeStamp.number ?? 0
  }
  
  /// Whether the event bubbles
  public var bubbles: Bool {
    jsValue.bubbles.boolean ?? false
  }
  
  /// Whether the event is cancelable
  public var cancelable: Bool {
    jsValue.cancelable.boolean ?? false
  }
  
  // MARK: - Modifier Keys
  
  /// Alt/Option key was pressed
  public var altKey: Bool {
    jsValue.altKey.boolean ?? false
  }
  
  /// Control key was pressed
  public var ctrlKey: Bool {
    jsValue.ctrlKey.boolean ?? false
  }
  
  /// Meta/Command key was pressed
  public var metaKey: Bool {
    jsValue.metaKey.boolean ?? false
  }
  
  /// Shift key was pressed
  public var shiftKey: Bool {
    jsValue.shiftKey.boolean ?? false
  }
  
  // MARK: - Event Methods
  
  /// Prevents the default action
  public func preventDefault() {
    _ = jsValue.preventDefault()
  }
  
  /// Stops event propagation
  public func stopPropagation() {
    _ = jsValue.stopPropagation()
  }
  
  /// Stops immediate propagation
  public func stopImmediatePropagation() {
    _ = jsValue.stopImmediatePropagation()
  }
}

/// Type of pointer device
public enum PointerType: String {
  case mouse
  case pen
  case touch
  case unknown
}

/// Represents a MouseEvent from the DOM
public struct MouseEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("MouseEvent {")
    parts.append("  type: \(type)")
    parts.append("  position: (\(clientX), \(clientY))")
    parts.append("  screen: (\(screenX), \(screenY))")
    parts.append("  page: (\(pageX), \(pageY))")
    parts.append("  offset: (\(offsetX), \(offsetY))")
    parts.append("  button: \(button)")
    parts.append("  buttons: \(buttons)")
    
    var modifiers: [String] = []
    if altKey { modifiers.append("Alt") }
    if ctrlKey { modifiers.append("Ctrl") }
    if metaKey { modifiers.append("Meta") }
    if shiftKey { modifiers.append("Shift") }
    parts.append("  modifiers: \(modifiers.isEmpty ? "none" : modifiers.joined(separator: "+"))")
    
    parts.append("  timestamp: \(timeStamp)")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  // Mouse position
  public var clientX: Double { jsValue.clientX.number ?? 0 }
  public var clientY: Double { jsValue.clientY.number ?? 0 }
  public var screenX: Double { jsValue.screenX.number ?? 0 }
  public var screenY: Double { jsValue.screenY.number ?? 0 }
  public var pageX: Double { jsValue.pageX.number ?? 0 }
  public var pageY: Double { jsValue.pageY.number ?? 0 }
  public var offsetX: Double { jsValue.offsetX.number ?? 0 }
  public var offsetY: Double { jsValue.offsetY.number ?? 0 }
  
  // Mouse buttons
  public var button: Int { Int(jsValue.button.number ?? 0) }
  public var buttons: Int { Int(jsValue.buttons.number ?? 0) }
  
  // Modifier keys
  public var altKey: Bool { jsValue.altKey.boolean ?? false }
  public var ctrlKey: Bool { jsValue.ctrlKey.boolean ?? false }
  public var metaKey: Bool { jsValue.metaKey.boolean ?? false }
  public var shiftKey: Bool { jsValue.shiftKey.boolean ?? false }
  
  // Event properties
  public var type: String { jsValue.type.string ?? "" }
  public var target: JSValue { jsValue.target }
  public var currentTarget: JSValue { jsValue.currentTarget }
  public var timeStamp: Double { jsValue.timeStamp.number ?? 0 }
  
  // Methods
  public func preventDefault() { _ = jsValue.preventDefault() }
  public func stopPropagation() { _ = jsValue.stopPropagation() }
}

/// Represents a KeyboardEvent from the DOM
public struct KeyboardEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("KeyboardEvent {")
    parts.append("  type: \(type)")
    parts.append("  key: \"\(key)\"")
    parts.append("  code: \"\(code)\"")
    parts.append("  keyCode: \(keyCode)")
    
    var modifiers: [String] = []
    if altKey { modifiers.append("Alt") }
    if ctrlKey { modifiers.append("Ctrl") }
    if metaKey { modifiers.append("Meta") }
    if shiftKey { modifiers.append("Shift") }
    parts.append("  modifiers: \(modifiers.isEmpty ? "none" : modifiers.joined(separator: "+"))")
    
    parts.append("  repeat: \(`repeat`)")
    parts.append("  isComposing: \(isComposing)")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  // Key information
  public var key: String { jsValue.key.string ?? "" }
  public var code: String { jsValue.code.string ?? "" }
  public var keyCode: Int { Int(jsValue.keyCode.number ?? 0) }
  public var charCode: Int { Int(jsValue.charCode.number ?? 0) }
  
  // Modifier keys
  public var altKey: Bool { jsValue.altKey.boolean ?? false }
  public var ctrlKey: Bool { jsValue.ctrlKey.boolean ?? false }
  public var metaKey: Bool { jsValue.metaKey.boolean ?? false }
  public var shiftKey: Bool { jsValue.shiftKey.boolean ?? false }
  
  // State
  public var `repeat`: Bool { jsValue.repeat.boolean ?? false }
  public var isComposing: Bool { jsValue.isComposing.boolean ?? false }
  
  // Event properties
  public var type: String { jsValue.type.string ?? "" }
  public var target: JSValue { jsValue.target }
  
  // Methods
  public func preventDefault() { _ = jsValue.preventDefault() }
  public func stopPropagation() { _ = jsValue.stopPropagation() }
}

/// Represents an InputEvent from the DOM
public struct InputEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("InputEvent {")
    parts.append("  type: \(type)")
    parts.append("  inputType: \"\(inputType)\"")
    parts.append("  data: \(data.map { "\"\($0)\"" } ?? "nil")")
    parts.append("  isComposing: \(isComposing)")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  // Input data
  public var data: String? { jsValue.data.string }
  public var inputType: String { jsValue.inputType.string ?? "" }
  public var isComposing: Bool { jsValue.isComposing.boolean ?? false }
  
  // Event properties
  public var type: String { jsValue.type.string ?? "" }
  public var target: JSValue { jsValue.target }
  
  // Methods
  public func preventDefault() { _ = jsValue.preventDefault() }
}

/// Represents a FocusEvent from the DOM
public struct FocusEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("FocusEvent {")
    parts.append("  type: \(type)")
    parts.append("  relatedTarget: \(relatedTarget != nil ? "present" : "nil")")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  // Focus-specific
  public var relatedTarget: JSValue? { jsValue.relatedTarget }
  
  // Event properties
  public var type: String { jsValue.type.string ?? "" }
  public var target: JSValue { jsValue.target }
  
  // Methods
  public func preventDefault() { _ = jsValue.preventDefault() }
}

/// Represents a generic Event from the DOM (fallback)
public struct GenericEvent: DOMEvent, CustomStringConvertible {
  public let jsValue: JSValue
  
  public init(jsValue: JSValue) {
    self.jsValue = jsValue
  }
  
  public var description: String {
    var parts: [String] = []
    parts.append("GenericEvent {")
    parts.append("  type: \(type)")
    parts.append("  timestamp: \(timeStamp)")
    parts.append("}")
    return parts.joined(separator: "\n")
  }
  
  public var type: String { jsValue.type.string ?? "" }
  public var target: JSValue { jsValue.target }
  public var currentTarget: JSValue { jsValue.currentTarget }
  public var timeStamp: Double { jsValue.timeStamp.number ?? 0 }
  
  public func preventDefault() { _ = jsValue.preventDefault() }
  public func stopPropagation() { _ = jsValue.stopPropagation() }
}

// MARK: - HTML Event Structure

public struct HTMLEvent {
  public let key: String
  public let handler: (sending JSValue) -> Void
}

public struct EventNode<Content: Node>: Node {
  var events: [HTMLEvent]
  public var content: Content
}

// MARK: - Type-Safe Event Extensions

extension HTMLElement {
  // MARK: - Pointer Events (Type-Safe)
  
  public func onPointerDown(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointerdown", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  public func onPointerUp(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointerup", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  public func onPointerMove(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointermove", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  public func onPointerEnter(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointerenter", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  public func onPointerLeave(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointerleave", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  public func onPointerCancel(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "pointercancel", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Mouse Events (Type-Safe)
  
  public func onMouseDown(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "mousedown", handler: { perform(MouseEvent(jsValue: $0)) })], content: self)
  }
  
  public func onMouseUp(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "mouseup", handler: { perform(MouseEvent(jsValue: $0)) })], content: self)
  }
  
  public func onMouseMove(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "mousemove", handler: { perform(MouseEvent(jsValue: $0)) })], content: self)
  }
  
  public func onMouseEnter(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "mouseenter", handler: { perform(MouseEvent(jsValue: $0)) })], content: self)
  }
  
  public func onMouseLeave(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "mouseleave", handler: { perform(MouseEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Click Events (Type-Safe with PointerEvent)
  
  /// Click event with type-safe PointerEvent
  public func onClick(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "click", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  /// Click event without parameters
  public func onClick(_ perform: @escaping () -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "click", handler: { _ in perform() })], content: self)
  }
  
  /// Double-click event
  public func onDoubleClick(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "dblclick", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  /// Context menu (right-click) event
  public func onContextMenu(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "contextmenu", handler: { perform(PointerEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Keyboard Events (Type-Safe)
  
  public func onKeyDown(_ perform: @escaping (KeyboardEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "keydown", handler: { perform(KeyboardEvent(jsValue: $0)) })], content: self)
  }
  
  public func onKeyUp(_ perform: @escaping (KeyboardEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "keyup", handler: { perform(KeyboardEvent(jsValue: $0)) })], content: self)
  }
  
  public func onKeyPress(_ perform: @escaping (KeyboardEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "keypress", handler: { perform(KeyboardEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Input Events (Type-Safe)
  
  public func onInput(_ perform: @escaping (InputEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "input", handler: { perform(InputEvent(jsValue: $0)) })], content: self)
  }
  
  public func onChange(_ perform: @escaping (GenericEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "change", handler: { perform(GenericEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Focus Events (Type-Safe)
  
  public func onFocus(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "focus", handler: { perform(FocusEvent(jsValue: $0)) })], content: self)
  }
  
  public func onBlur(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "blur", handler: { perform(FocusEvent(jsValue: $0)) })], content: self)
  }
  
  public func onFocusIn(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "focusin", handler: { perform(FocusEvent(jsValue: $0)) })], content: self)
  }
  
  public func onFocusOut(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "focusout", handler: { perform(FocusEvent(jsValue: $0)) })], content: self)
  }
  
  // MARK: - Generic Events
  
  public func onSubmit(_ perform: @escaping (GenericEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "submit", handler: { perform(GenericEvent(jsValue: $0)) })], content: self)
  }
  
  public func onScroll(_ perform: @escaping (GenericEvent) -> Void) -> EventNode<Self> {
    EventNode(events: [.init(key: "scroll", handler: { perform(GenericEvent(jsValue: $0)) })], content: self)
  }
}

// MARK: - Type-Safe Event Extensions for EventNode

extension EventNode {
  // MARK: - Pointer Events
  
  public func onPointerDown(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "pointerdown", handler: { perform(PointerEvent(jsValue: $0)) })], content: content)
  }
  
  public func onPointerUp(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "pointerup", handler: { perform(PointerEvent(jsValue: $0)) })], content: content)
  }
  
  public func onPointerMove(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "pointermove", handler: { perform(PointerEvent(jsValue: $0)) })], content: content)
  }
  
  // MARK: - Click Events
  
  public func onClick(_ perform: @escaping (PointerEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "click", handler: { perform(PointerEvent(jsValue: $0)) })], content: content)
  }
  
  public func onClick(_ perform: @escaping () -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "click", handler: { _ in perform() })], content: content)
  }
  
  // MARK: - Mouse Events
  
  public func onMouseDown(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "mousedown", handler: { perform(MouseEvent(jsValue: $0)) })], content: content)
  }
  
  public func onMouseMove(_ perform: @escaping (MouseEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "mousemove", handler: { perform(MouseEvent(jsValue: $0)) })], content: content)
  }
  
  // MARK: - Keyboard Events
  
  public func onKeyDown(_ perform: @escaping (KeyboardEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "keydown", handler: { perform(KeyboardEvent(jsValue: $0)) })], content: content)
  }
  
  public func onKeyUp(_ perform: @escaping (KeyboardEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "keyup", handler: { perform(KeyboardEvent(jsValue: $0)) })], content: content)
  }
  
  // MARK: - Input Events
  
  public func onInput(_ perform: @escaping (InputEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "input", handler: { perform(InputEvent(jsValue: $0)) })], content: content)
  }
  
  public func onChange(_ perform: @escaping (GenericEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "change", handler: { perform(GenericEvent(jsValue: $0)) })], content: content)
  }
  
  // MARK: - Focus Events
  
  public func onFocus(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "focus", handler: { perform(FocusEvent(jsValue: $0)) })], content: content)
  }
  
  public func onBlur(_ perform: @escaping (FocusEvent) -> Void) -> EventNode<Content> {
    EventNode(events: events + [.init(key: "blur", handler: { perform(FocusEvent(jsValue: $0)) })], content: content)
  }
}
