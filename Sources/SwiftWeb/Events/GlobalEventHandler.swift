import JavaScriptKit

typealias EventName = String

let supportedEvents = [
  // Clipboard Events
  "copy", "cut", "paste",
  
  // Composition Events
  "compositionend", "compositionstart", "compositionupdate",
  
  // Keyboard Events
  "keydown", "keypress", "keyup",
  
  // Focus Events
  "focus", "blur", "focusin", "focusout",
  
  // Form Events
  "change", "input", "invalid", "submit", "reset",
  
  // Mouse Events
  "click", "contextmenu", "doubleclick", "dblclick",
  "drag", "dragend", "dragenter", "dragleave", "dragover", "dragstart", "drop",
  "mousedown", "mouseenter", "mouseleave", "mousemove", "mouseout", "mouseover", "mouseup",
  
  // Pointer Events
  "pointerdown", "pointermove", "pointerup", "pointercancel",
  "pointerenter", "pointerleave", "pointerover", "pointerout",
  "gotpointercapture", "lostpointercapture",
  
  // Selection Events
  "select", "selectionchange",
  
  // Touch Events
  "touchcancel", "touchend", "touchmove", "touchstart",
  
  // UI Events
  "scroll", "resize",
  
  // Wheel Events
  "wheel",
  
  // Media Events
  "abort", "canplay", "canplaythrough", "durationchange", "emptied", "encrypted",
  "ended", "error", "loadeddata", "loadedmetadata", "loadstart",
  "pause", "play", "playing", "progress", "ratechange",
  "seeked", "seeking", "stalled", "suspend", "timeupdate", "volumechange", "waiting",
  
  // Animation Events
  "animationstart", "animationend", "animationiteration",
  
  // Transition Events
  "transitionend", "transitionstart", "transitioncancel", "transitionrun",
  
  // Other Events
  "load", "unload", "beforeunload",
  "toggle"
]

class GlobalEventHandler {
  private var eventHandlers: [JSObject: [EventName: [EventHandler]]] = [:]
  
  init() {
    setupEventDelegation()
  }
  
  func setEventHandlers(name: String, element: JSObject, handlers: [EventHandler]) {
    if eventHandlers[element] == nil {
      eventHandlers[element] = [:]
    }
    eventHandlers[element]?[name] = handlers
  }
  
  func removeEventHandlers(for element: JSObject) {
    eventHandlers[element] = nil
  }
  
  func dispatchEvent(_ eventValue: JSValue) {
    guard let jsEvt = eventValue.object else { return }
    guard let type = jsEvt.type.string else { return }
    
    var current: JSObject? = jsEvt.target.object
    while let el = current {
      if let handlers = eventHandlers[el]?[type] {
        for handler in handlers {
          handler(eventValue)
        }
        return
      }
      current = el.parentNode.object
    }
  }
  
  // MARK: - Event Delegation Setup
  func setupEventDelegation() {
    #if arch(wasm32)
    for eventName in supportedEvents {
      _ = JSObject.global.document.addEventListener(eventName, JSClosure { [weak self] args in
        self?.dispatchEvent(args[0])
        return .undefined
      })
    }
    #endif
  }
}
