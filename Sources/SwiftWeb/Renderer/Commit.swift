import SwiftHTML
import JavaScriptKit
import Foundation

// MARK: - Commit Phase

/// The commit phase applies all changes to the DOM
/// This phase is SYNCHRONOUS and CANNOT be interrupted
/// It must be fast because it blocks the main thread
final class CommitPhase {
  
  let globalEventHandler = GlobalEventHandler()

  // MARK: - Main Entry Point

  /// Commit all work - apply changes to the DOM
  /// This executes in three sub-phases:
  /// 1. Before Mutation - prepare for changes
  /// 2. Mutation - apply DOM changes
  /// 3. Layout - finalize and run effects
  func commitRoot(_ finishedWork: Fiber, deletions: [Fiber]) {
    #if arch(wasm32)
    // Phase 1: Before Mutation
    // In React, this is where getSnapshotBeforeUpdate runs
    // We don't have that in SwiftWeb yet
    commitBeforeMutationEffects(finishedWork)

    // Phase 2: Mutation Phase - Apply all DOM changes
    commitMutationEffects(finishedWork, deletions: deletions)

    // Phase 3: Layout Phase - Finalize
    // In React, this is where componentDidMount/Update and useLayoutEffect run
    commitLayoutEffects(finishedWork)
    #endif
  }

  // MARK: - Phase 1: Before Mutation

  private func commitBeforeMutationEffects(_ fiber: Fiber) {
    // Currently empty - this is where you'd capture DOM state before mutations
    // e.g., scroll position, focus state, etc.
  }

  // MARK: - Phase 2: Mutation Effects

  /// Apply all DOM mutations
  private func commitMutationEffects(_ fiber: Fiber, deletions: [Fiber]) {
    // First, process deletions
    for deletion in deletions {
      commitDeletion(deletion)
    }

    // Then, process the fiber tree
    commitMutationEffectsOnFiber(fiber)
  }

  /// Commit mutation effects on a single fiber and its subtree
  private func commitMutationEffectsOnFiber(_ fiber: Fiber) {
    let flags = fiber.flags

    // Process this fiber's effects
    if flags.contains(.placement) {
      commitPlacement(fiber)
      // Remove the placement flag
      fiber.flags.remove(.placement)
    }

    if flags.contains(.update) {
      commitUpdate(fiber)
      // Remove the update flag
      fiber.flags.remove(.update)
    }

    // Recursively process children
    var child = fiber.child
    while let c = child {
      commitMutationEffectsOnFiber(c)
      child = c.sibling
    }
  }

  // MARK: - Placement

  /// Insert a fiber into the DOM
  private func commitPlacement(_ fiber: Fiber) {
    // Skip component fibers - they don't have DOM nodes
    if fiber.isComponent {
      // Process children directly
      var child = fiber.child
      while let c = child {
        commitPlacement(c)
        child = c.sibling
      }
      return
    }

    // Create DOM node if it doesn't exist
    if fiber.stateNode == nil {
      fiber.stateNode = createDOMNode(fiber)

      // Attach event listeners
      if !fiber.events.isEmpty {
        attachEventListeners(fiber)
      }
    }

    guard let domNode = fiber.stateNode else { return }

    // Find the parent DOM node
    guard let parentDOMNode = findParentDOMNode(fiber) else {
      // No parent - this must be the root
      if fiber.type == "body" {
        _ = JSObject.global.document.body.replaceWith(domNode)
      } else {
        _ = JSObject.global.document.body.appendChild(domNode)
      }

      // NOTE: Don't recursively place children here!
      // Children will be processed by commitMutationEffectsOnFiber's traversal
      return
    }

    // Insert into parent at the correct position
    insertNodeAtCorrectPosition(node: domNode, fiber: fiber, parent: parentDOMNode)

    // NOTE: Don't recursively place children here!
    // Children will be processed by commitMutationEffectsOnFiber's traversal
  }

  // MARK: - Update

  /// Update a fiber's DOM node
  private func commitUpdate(_ fiber: Fiber) {
    guard let domNode = fiber.stateNode else { return }

    if fiber.isTextNode {
      // Update text content
      domNode.nodeValue = .string(fiber.textContent ?? "")
    } else {
      // Update attributes
      let oldProps = fiber.alternate?.memoizedProps ?? [:]
      let newProps = fiber.pendingProps  // ✅ Use pendingProps, not memoizedProps!

      updateAttributes(node: domNode, oldProps: oldProps, newProps: newProps)
    }
  }

  // MARK: - Deletion

  /// Remove a fiber from the DOM
  private func commitDeletion(_ fiber: Fiber) {
    // Skip components - find their host children
    if fiber.isComponent {
      var child = fiber.child
      while let c = child {
        commitDeletion(c)
        child = c.sibling
      }
      return
    }

    // Remove the DOM node
    if let domNode = fiber.stateNode {
      globalEventHandler.removeEventHandlers(for: domNode)
      _ = domNode.remove?()
    }

    // Recursively delete children
    var child = fiber.child
    while let c = child {
      commitDeletion(c)
      child = c.sibling
    }
  }

  // MARK: - Phase 3: Layout Effects

  private func commitLayoutEffects(_ fiber: Fiber) {
    // This is where componentDidMount/Update would run
    // And where we'd update refs
    commitLayoutEffectsOnFiber(fiber)
  }

  private func commitLayoutEffectsOnFiber(_ fiber: Fiber) {
    // Process children
    var child = fiber.child
    while let c = child {
      commitLayoutEffectsOnFiber(c)
      child = c.sibling
    }
  }

  // MARK: - DOM Operations

  /// Create a DOM node for a fiber
  private func createDOMNode(_ fiber: Fiber) -> JSObject {
    let document = JSObject.global.document.object!

    if fiber.isTextNode {
      return document.createTextNode!(fiber.textContent ?? "").object!
    }

    let element = document.createElement!(fiber.type).object!

    // Set attributes
    setAttributes(element, fiber.pendingProps)

    return element
  }

  /// Set attributes on a DOM element
  private func setAttributes(_ element: JSObject, _ attributes: [String: String]) {
    for (key, value) in attributes {
      _ = element.setAttribute?(key, value)
    }
  }

  /// Update attributes on a DOM element
  private func updateAttributes(
    node: JSObject,
    oldProps: [String: String],
    newProps: [String: String]
  ) {
    // Remove old attributes
    for (key, _) in oldProps where newProps[key] == nil {
      _ = node.removeAttribute?(key)
    }

    // Add/update new attributes
    for (key, value) in newProps where oldProps[key] != value {
      _ = node.setAttribute?(key, value)
    }
  }

  // MARK: - Event Listeners

  /// Attach event listeners to a DOM node
  private func attachEventListeners(_ fiber: Fiber) {
    guard let node = fiber.stateNode else { return }

    for (eventName, handlers) in fiber.events {
      globalEventHandler.setEventHandlers(name: eventName, element: node, handlers: handlers)
    }
  }

  // MARK: - DOM Tree Traversal

  /// Find the parent DOM node by traversing up the fiber tree
  private func findParentDOMNode(_ fiber: Fiber) -> JSObject? {
    var parent = fiber.parent

    while let p = parent {
      // Component fibers don't have DOM nodes
      if !p.isComponent, let domNode = p.stateNode {
        return domNode
      }
      parent = p.parent
    }

    return nil
  }

  /// Insert a DOM node at the correct position in its parent
  private func insertNodeAtCorrectPosition(
    node: JSObject,
    fiber: Fiber,
    parent: JSObject
  ) {
    // Find the next sibling DOM node (for correct insertion position)
    if let beforeNode = getNextSiblingDOMNode(fiber) {
      _ = parent.insertBefore?(node, beforeNode)
    } else {
      _ = parent.appendChild?(node)
    }
  }

  /// Get the DOM node of the next sibling fiber
  private func getNextSiblingDOMNode(_ fiber: Fiber) -> JSObject? {
    guard let parent = fiber.parent else { return nil }

    // Find this fiber among parent's children
    var current = parent.child
    var found = false

    while let c = current {
      if found {
        // This is a sibling after our fiber
        if let domNode = getFirstDOMNode(c) {
          return domNode
        }
      }

      if c === fiber {
        found = true
      }

      current = c.sibling
    }

    // No sibling found at this level - check parent's siblings
    if parent.isComponent {
      return getNextSiblingDOMNode(parent)
    }

    return nil
  }

  /// Get the first DOM node in a fiber subtree
  private func getFirstDOMNode(_ fiber: Fiber) -> JSObject? {
    if fiber.isComponent {
      // Component - look in children
      var child = fiber.child
      while let c = child {
        if let domNode = getFirstDOMNode(c) {
          return domNode
        }
        child = c.sibling
      }
      return nil
    }

    return fiber.stateNode
  }
}
