import SwiftHTML
import JavaScriptKit
import Foundation

private(set) var treeRenderer: TreeRenderer?

final class TreeRenderer {
  let converter = FiberConverter()

  var current: Fiber?
  var deletions: [Fiber] = []
  var firstEffect: Fiber?
  var lastEffect: Fiber?
  
  #if DEBUG
  var enableLogging = false
  #else
  var enableLogging = false
  #endif
  
  private(set) var render: (() -> Void)!
  
  func start(app: @autoclosure @escaping () -> some App) {
    treeRenderer = self
    render = { [weak self] in
      self?.performWork(newTree: app())
    }
    render()
  }
  
  // MARK: - Reconciliation
  
  /// Main entry point for updates
  func performWork(newTree: some Node) {
    // Clear deletions from previous render
    deletions.removeAll(keepingCapacity: true)

    let newFibers = converter.convert(newTree)

    guard let newRoot = newFibers.first else { return }

    // Start reconciliation from root
    let newTree = reconcile(current: current, new: newRoot)

    // Update state references to point to reconciled fibers
    updateStateReferences(in: newTree)

    // Build effect list in correct order (parent-first)
    collectEffects(from: newTree)

    // Commit all changes
    #if arch(wasm32)
    commitWork()
    #endif

    // Update current tree
    current = newTree
  }

  /// Re-render from a specific fiber node (for component updates)
  func render(from fiber: Fiber) {
    guard let stateful = fiber.sourceNode as? any ComponentNode else {
      render()
      return
    }

    // Clear deletions from previous render
    deletions.removeAll(keepingCapacity: true)

    stateful.__bindStorage(with: fiber)
    let content = stateful.content

    // Convert content to fibers
    let newContentFibers: [Fiber]
    if let visitable = content as? FiberConvertible {
      newContentFibers = visitable.convert(using: converter)
    } else {
      newContentFibers = converter.convert(content)
    }

    // Reconcile to generate effects
    let oldChildren = fiber.children
    fiber.children = []
    reconcileChildren(wipFiber: fiber, oldChildren: oldChildren, newChildren: newContentFibers)

    // Update state references to point to reconciled fibers
    updateStateReferences(in: fiber)

    // Build effect list in correct order (parent-first)
    collectEffects(from: fiber)

    // Now commit (effects exist now!)
#if arch(wasm32)
    commitWork()
#endif
  }

  /// Update state box references to point to reconciled fibers
  private func updateStateReferences(in fiber: Fiber) {
    // If this is a component fiber, rebind state to the reconciled fiber
    if let stateful = fiber.sourceNode as? any ComponentNode {
      stateful.__bindStorage(with: fiber)
    }

    // Recursively update children
    for child in fiber.children {
      updateStateReferences(in: child)
    }
  }

  /// Collect effects starting from a fiber subtree
  private func collectEffects(from fiber: Fiber?) {
    guard let fiber = fiber else { return }

    // Clear previous effects (but NOT deletions - they're set during reconciliation)
    firstEffect = nil
    lastEffect = nil
    // DON'T clear deletions here - they're populated during reconciliation!

    // Build the effect list
    buildEffectList(fiber: fiber)
  }

  /// Build effect list from a fiber and its children
  private func buildEffectList(fiber: Fiber) {
    // Add this fiber's effect FIRST (parent before children for placement)
    if fiber.effectTag != .none {
      if lastEffect == nil {
        firstEffect = fiber
        lastEffect = fiber
      } else {
        lastEffect?.nextEffect = fiber
        lastEffect = fiber
      }
      fiber.nextEffect = nil
    }

    // Then process children
    for child in fiber.children {
      buildEffectList(fiber: child)
    }
  }

  
  /// Reconcile two fiber trees - returns new work-in-progress fiber
  private func reconcile(current: Fiber?, new: Fiber) -> Fiber {
    // Create work-in-progress fiber
    let wipFiber = Fiber(tag: new.tag, key: new.key, attributes: new.attributes, textContent: new.textContent, events: new.events)
    wipFiber.states = current?.states ?? [:]
    wipFiber.alternate = current
    wipFiber.domNode = current?.domNode

    // Preserve source node for re-rendering
    wipFiber.sourceNode = new.sourceNode

    // Determine effect tag
    if current == nil {
      // New fiber - needs placement
      wipFiber.effectTag = .placement
    } else if !canReuse(current: current!, new: new) {
      // Tags differ - needs replacement
      wipFiber.effectTag = .placement
      if let oldFiber = current {
        oldFiber.effectTag = .deletion
        deletions.append(oldFiber)
      }
    } else if attributesChanged(current: current!, new: new) || textContentChanged(current: current!, new: new) || eventsChanged(current: current!, new: new) {
      // Same tag, different attributes, text, or events - needs update
      wipFiber.effectTag = .update
    }

    // Reconcile children
    // For component fibers, regenerate children with preserved state
    let newChildren: [Fiber]
    if wipFiber.isComponent, let component = wipFiber.sourceNode as? any ComponentNode {
      // Rebind component to wipFiber so it reads preserved state
      component.__bindStorage(with: wipFiber)

      // Regenerate children with correct state
      let content = component.content
      if let convertible = content as? FiberConvertible {
        newChildren = convertible.convert(using: converter)
      } else {
        newChildren = converter.convert(content)
      }
    } else {
      newChildren = new.children
    }

    reconcileChildren(wipFiber: wipFiber, oldChildren: current?.children ?? [], newChildren: newChildren)

    return wipFiber
  }
  
  // MARK: - Fiber Comparison Helpers

  /// Check if fibers can be reused (same type and key)
  @inline(__always)
  private func canReuse(current: Fiber, new: Fiber) -> Bool {
    // Tags must match
    guard current.tag == new.tag else { return false }

    // Handle key matching
    switch (current.key, new.key) {
    case (nil, nil):
      // Both have no keys - can reuse based on tag
      return true
    case let (currentKey?, newKey?):
      // Both have keys - they must match
      return currentKey == newKey
    default:
      // One has a key and the other doesn't - can't reuse
      return false
    }
  }

  /// Check if attributes changed between two fibers
  @inline(__always)
  private func attributesChanged(current: Fiber, new: Fiber) -> Bool {
    guard current.attributes.count == new.attributes.count else { return true }
    return new.attributes.contains { current.attributes[$0.key] != $0.value }
  }

  /// Check if text content changed between two fibers
  @inline(__always)
  private func textContentChanged(current: Fiber, new: Fiber) -> Bool {
    current.textContent != new.textContent
  }

  /// Check if events changed between two fibers
  @inline(__always)
  private func eventsChanged(current: Fiber, new: Fiber) -> Bool {
    guard current.events.count == new.events.count else { return true }
    // Check if all event keys are present (we can't compare closures directly)
    return new.events.keys.contains { current.events[$0] == nil }
  }
  
  /// Reconcile children using optimized diffing algorithm
  private func reconcileChildren(wipFiber: Fiber, oldChildren: [Fiber], newChildren: [Fiber]) {
    // Check if we should use key-based reconciliation
    let useKeys = newChildren.first?.key != nil

    if useKeys {
      reconcileChildrenByKey(wipFiber: wipFiber, oldChildren: oldChildren, newChildren: newChildren)
    } else {
      reconcileChildrenByTag(wipFiber: wipFiber, oldChildren: oldChildren, newChildren: newChildren)
    }
  }

  /// Key-based reconciliation for lists (much faster for large lists)
  private func reconcileChildrenByKey(wipFiber: Fiber, oldChildren: [Fiber], newChildren: [Fiber]) {
    // Build a map of old children by key with their index for O(1) lookups
    var oldChildrenMap: [AnyHashable: (fiber: Fiber, index: Int)] = [:]
    oldChildrenMap.reserveCapacity(oldChildren.count)

    for (index, oldChild) in oldChildren.enumerated() {
      if let key = oldChild.key {
        oldChildrenMap[key] = (oldChild, index)
      }
    }

    wipFiber.children.reserveCapacity(newChildren.count)
    var lastPlacedIndex = 0

    // Process each new child
    for newChild in newChildren {
      guard let key = newChild.key else { continue }

      if let (matchingOld, oldPosition) = oldChildrenMap[key] {
        // Found exact key match
        let reconciledChild = reconcile(current: matchingOld, new: newChild)
        reconciledChild.parent = wipFiber

        wipFiber.children.append(reconciledChild)

        // Remove from map
        oldChildrenMap.removeValue(forKey: key)

        // Check if we need to move this node
        if oldPosition < lastPlacedIndex {
          // This node moved backwards - needs reordering
          reconciledChild.effectTag = .placement
        } else {
          lastPlacedIndex = oldPosition
        }
      } else {
        // No match - create new fiber
        let reconciledChild = reconcile(current: nil, new: newChild)
        reconciledChild.parent = wipFiber
        wipFiber.children.append(reconciledChild)
      }
    }

    // Mark remaining old children for deletion
    for (_, (oldFiber, _)) in oldChildrenMap {
      oldFiber.effectTag = .deletion
      deletions.append(oldFiber)
    }

    // Collect effects from children
    for child in wipFiber.children {
      if child.effectTag != .none {
        appendEffect(child)
      }
    }
  }

  /// Tag-based reconciliation for non-keyed children (fallback)
  private func reconcileChildrenByTag(wipFiber: Fiber, oldChildren: [Fiber], newChildren: [Fiber]) {
    var oldIndex = 0
    var newIndex = 0
    var lastPlacedIndex = 0

    // Build a map of old children by tag for O(1) lookups
    var oldChildrenMap: [String: [Fiber]] = [:]
    for oldChild in oldChildren {
      oldChildrenMap[oldChild.tag, default: []].append(oldChild)
    }

    wipFiber.children.reserveCapacity(newChildren.count)

    // Phase 1: Try to match children in order (common case optimization)
    while oldIndex < oldChildren.count && newIndex < newChildren.count {
      let oldChild = oldChildren[oldIndex]
      let newChild = newChildren[newIndex]

      if canReuse(current: oldChild, new: newChild) {
        // Reuse and reconcile
        let reconciledChild = reconcile(current: oldChild, new: newChild)
        reconciledChild.parent = wipFiber
        wipFiber.children.append(reconciledChild)

        // Remove from map since it's been matched
        if var siblings = oldChildrenMap[oldChild.tag] {
          siblings.removeFirst()
          if siblings.isEmpty {
            oldChildrenMap.removeValue(forKey: oldChild.tag)
          } else {
            oldChildrenMap[oldChild.tag] = siblings
          }
        }

        lastPlacedIndex = oldIndex
        oldIndex += 1
        newIndex += 1
      } else {
        break
      }
    }

    // Phase 2: Handle remaining new children
    while newIndex < newChildren.count {
      let newChild = newChildren[newIndex]

      // Try to find matching old child in map
      if let matchingOld = oldChildrenMap[newChild.tag]?.first {
        // Found a match - reuse it
        let reconciledChild = reconcile(current: matchingOld, new: newChild)
        reconciledChild.parent = wipFiber
        wipFiber.children.append(reconciledChild)

        // Remove from map
        var siblings = oldChildrenMap[newChild.tag]!
        siblings.removeFirst()
        if siblings.isEmpty {
          oldChildrenMap.removeValue(forKey: newChild.tag)
        } else {
          oldChildrenMap[newChild.tag] = siblings
        }

        // Mark for potential repositioning if moved
        if let oldPosition = oldChildren.firstIndex(where: { $0 === matchingOld }) {
          if oldPosition < lastPlacedIndex {
            reconciledChild.effectTag = .placement
          }
          lastPlacedIndex = max(lastPlacedIndex, oldPosition)
        }
      } else {
        // No match - create new fiber
        let reconciledChild = reconcile(current: nil, new: newChild)
        reconciledChild.parent = wipFiber
        wipFiber.children.append(reconciledChild)
      }

      newIndex += 1
    }

    // Phase 3: Mark remaining old children for deletion
    for (_, remainingOld) in oldChildrenMap {
      for oldFiber in remainingOld {
        oldFiber.effectTag = .deletion
        deletions.append(oldFiber)
      }
    }

    // Collect effects from children
    for child in wipFiber.children {
      if child.effectTag != .none {
        appendEffect(child)
      }
    }
  }
  
  /// Append fiber to effect list
  private func appendEffect(_ fiber: Fiber) {
    if lastEffect == nil {
      firstEffect = fiber
      lastEffect = fiber
    } else {
      lastEffect?.nextEffect = fiber
      lastEffect = fiber
    }
  }
  
  // MARK: - Commit Phase
  
  /// Commit all changes to the DOM in a single batch
  private func commitWork() {
    // Process deletions first
    for deletion in deletions {
      commitDeletion(deletion)
    }
    deletions.removeAll(keepingCapacity: true)

    // Process effects
    var effect = firstEffect
    var effectCount = 0
    while let currentEffect = effect {
      effectCount += 1
      commitEffect(currentEffect)
      effect = currentEffect.nextEffect
    }

    // Clear effect list
    firstEffect = nil
    lastEffect = nil
  }
  
  private func commitEffect(_ fiber: Fiber) {
    switch fiber.effectTag {
    case .placement:
      commitPlacement(fiber)
    case .update:
      commitUpdate(fiber)
    case .deletion:
      commitDeletion(fiber)
    case .none:
      break
    }
    
    // Reset effect tag
    fiber.effectTag = .none
  }
  
  private func commitPlacement(_ fiber: Fiber) {
    // Component wrappers don't have DOM nodes - recursively place their children
    if fiber.isComponent {
      for child in fiber.children {
        if child.effectTag == .placement {
          commitPlacement(child)
        }
      }
      return
    }

    // Create DOM node if it doesn't exist
    if fiber.domNode == nil {
      fiber.domNode = createDOMNode(fiber)
      if let node = fiber.domNode {
        attachEventListeners(node: node, fiber: fiber, events: fiber.events)
      }
    } else {
      // Node already exists (shuffle/reorder case) - move it to correct position
      guard let node = fiber.domNode else { return }
      guard let parentNode = findParentDOMNode(fiber: fiber) else { return }

      // Reorder: remove from current position and insert at correct position
      insertNodeAtCorrectPosition(node: node, fiber: fiber, parent: parentNode)
      return
    }

    guard let node = fiber.domNode else { return }

    // Find parent DOM node, traversing up through component wrappers if needed
    guard let parentNode = findParentDOMNode(fiber: fiber) else {
      // No parent means this is the root
      if fiber.tag == "html" {
        // Replace entire document element
        _ = JSObject.global.document.object!.documentElement.replaceWith(node)
      } else {
        // Append to document body for non-html root elements
        _ = JSObject.global.document.body.appendChild(node)
      }
      return
    }

    // Insert node at the correct position
    insertNodeAtCorrectPosition(node: node, fiber: fiber, parent: parentNode)
  }

  /// Find the parent DOM node by traversing up the fiber tree
  private func findParentDOMNode(fiber: Fiber) -> JSObject? {
    var parentFiber = fiber.parent
    while let parent = parentFiber {
      if let domNode = parent.domNode {
        return domNode
      }
      parentFiber = parent.parent
    }
    return nil
  }

  /// Insert a DOM node at the correct position in its parent
  private func insertNodeAtCorrectPosition(node: JSObject, fiber: Fiber, parent: JSObject) {
    if let beforeNode = getNextSiblingDOMNode(fiber: fiber) {
      // Insert before the next sibling
      _ = parent.insertBefore?(node, beforeNode)
    } else {
      // No next sibling, append at the end
      _ = parent.appendChild?(node)
    }
  }

  /// Find the DOM node of the next sibling fiber in the tree
  private func getNextSiblingDOMNode(fiber: Fiber) -> JSObject? {
    guard let parent = fiber.parent else { return nil }

    // Find this fiber's index in parent's children
    guard let currentIndex = parent.children.firstIndex(where: { $0 === fiber }) else {
      return nil
    }

    // Look for the next sibling with a DOM node
    for i in (currentIndex + 1)..<parent.children.count {
      let sibling = parent.children[i]
      if let domNode = getFirstDOMNode(fiber: sibling) {
        return domNode
      }
    }

    // No sibling found at this level
    // If parent is a component wrapper, look for siblings of the component
    if parent.isComponent {
      return getNextSiblingDOMNode(fiber: parent)
    }

    return nil
  }

  /// Get the first DOM node in a fiber subtree (skipping component wrappers)
  private func getFirstDOMNode(fiber: Fiber) -> JSObject? {
    if fiber.tag == "#component" {
      // Component wrapper - look in children
      for child in fiber.children {
        if let domNode = getFirstDOMNode(fiber: child) {
          return domNode
        }
      }
      return nil
    }
    return fiber.domNode
  }
  
  private func commitUpdate(_ fiber: Fiber) {
    // Skip component wrappers
    if fiber.tag == "#component" {
      return
    }

    guard let node = fiber.domNode else { return }

    // Update text content for text nodes
    if fiber.tag == "#text" {
      if let textContent = fiber.textContent {
        node.nodeValue = .string(textContent)
      }
    } else {
      // Update attributes for elements
      updateAttributes(node: node, oldAttrs: fiber.alternate?.attributes ?? [:], newAttrs: fiber.attributes)
      
      // Update event listeners
      updateEventListeners(node: node, fiber: fiber, oldEvents: fiber.alternate?.events ?? [:], newEvents: fiber.events)
    }
  }
  
  private func commitDeletion(_ fiber: Fiber) {
    // Component wrappers don't have DOM nodes, just delete children
    if fiber.tag == "#component" {
      for child in fiber.children {
        commitDeletion(child)
      }
      return
    }

    if let node = fiber.domNode {
      _ = node.remove?()
    }

    // Recursively delete children
    for child in fiber.children {
      commitDeletion(child)
    }
  }
  
  // MARK: - DOM Operations
  
  private func createDOMNode(_ fiber: Fiber) -> JSObject {
    let document = JSObject.global.document.object!

    // Handle text nodes
    if fiber.isTextNode {
      return document.createTextNode!(fiber.textContent ?? "").object!
    }

    // Create element (WITHOUT children - let effect list handle placement)
    let element = document.createElement!(fiber.tag).object!

    // Set attributes
    setAttributes(on: element, from: fiber.attributes)

    // Don't create children here - they will be placed via their own effects
    // This is the React Fiber way: each node is responsible for its own placement

    return element
  }

  /// Set attributes on a DOM element
  private func setAttributes(on element: JSObject, from attributes: [String: String]) {
    for (key, value) in attributes {
      _ = element.setAttribute?(key, value)
    }
  }
  
  private func updateAttributes(node: JSObject, oldAttrs: [String: String], newAttrs: [String: String]) {
    // Remove old attributes not in new
    for (key, _) in oldAttrs where newAttrs[key] == nil {
      _ = node.removeAttribute?(key)
    }
    
    // Add/update new attributes
    for (key, value) in newAttrs where oldAttrs[key] != value {
      _ = node.setAttribute?(key, value)
    }
  }
  
  // MARK: - Event Listener Management
  
  /// Attach event listeners to a DOM node
  private func attachEventListeners(node: JSObject, fiber: Fiber, events: [String: EventHandler]) {
    for (eventType, handler) in events {
      attachEventListener(to: node, eventType: eventType, handler: handler)
    }
  }

  /// Attach a single event listener to a DOM node
  private func attachEventListener(to node: JSObject, eventType: String, handler: @escaping EventHandler) {
    // Create a JSClosure that wraps the Swift handler
    let closure = JSClosure { args in
      guard !args.isEmpty else { return .undefined }
      handler(args[0])
      return .undefined
    }

    // Store closure on DOM node to prevent deallocation
    let closureKey = "_swiftClosure_\(eventType)"
    node[closureKey] = .object(closure)

    // Add event listener
    _ = node.addEventListener?(eventType, closure)
  }
  
  /// Update event listeners on a DOM node
  private func updateEventListeners(node: JSObject, fiber: Fiber, oldEvents: [String: (sending JSValue) -> Void], newEvents: [String: (sending JSValue) -> Void]) {
    // Remove old event listeners that are no longer present
    for (eventType, _) in oldEvents where newEvents[eventType] == nil {
      removeEventListener(node: node, eventType: eventType)
    }
    
    // Add or update event listeners
    // Since we can't compare closures, we'll remove and re-add all new events
    for (eventType, handler) in newEvents {
      // Remove old listener if it exists
      if oldEvents[eventType] != nil {
        removeEventListener(node: node, eventType: eventType)
      }
      
      // Create a JSClosure that wraps the Swift handler
      let closure = JSClosure { args in
        let event = args[0]
        handler(event)
        return JSValue.undefined
      }
      
      // Store the closure on the node
      let closureKey = "_swiftClosure_\(eventType)"
      node[closureKey] = .object(closure)
      
      // Add event listener
      _ = node.addEventListener?(eventType, closure)
    }
  }
  
  /// Remove an event listener from a DOM node
  private func removeEventListener(node: JSObject, eventType: String) {
    let closureKey = "_swiftClosure_\(eventType)"
    
    // Get the stored closure
    if let closureValue = node[closureKey].object {
      // Remove the event listener
      _ = node.removeEventListener?(eventType, closureValue)
      
      // Clear the stored closure
      node[closureKey] = .undefined
    }
  }
}
