import SwiftHTML
import JavaScriptKit
import Foundation

// MARK: - Reconciler

/// The reconciler is responsible for the "render phase" - determining what needs to change
/// This phase is INTERRUPTIBLE and can be paused/resumed
final class Reconciler {

  // MARK: - Properties

  /// The converter for turning Nodes into Fibers
  let converter = FiberConverter()

  /// Fibers marked for deletion (collected during reconciliation)
  private var deletions: [Fiber] = []

  // MARK: - Main Entry Point

  /// Begin reconciliation work starting from the root
  /// Returns the completed work-in-progress tree
  func reconcile(
    current: Fiber?,
    newElement: some Node,
    lane: Lane
  ) -> Fiber? {
    // Convert the new element to a fiber tree
    guard let newFiber = converter.convert(newElement, lane: lane) else {
      return nil
    }

    // Start reconciliation
    let workInProgress = reconcileFiber(
      current: current,
      newFiber: newFiber,
      lane: lane
    )

    // Update state references after reconciliation
    updateStateReferences(in: workInProgress)

    // Build the effect list (collected during completeWork)
    // This will be done during the work loop

    return workInProgress
  }

  // MARK: - Reconcile Single Fiber

  /// Reconcile a single fiber node (similar to React's reconcileSingleElement)
  func reconcileFiber(
    current: Fiber?,
    newFiber: Fiber,
    lane: Lane
  ) -> Fiber {

    // Create work-in-progress fiber
    let workInProgress: Fiber

    if let current = current {
      // Reuse existing fiber if possible
      if canReuse(current: current, new: newFiber) {
        // Same type and key - create WIP from current
        workInProgress = Fiber.createWorkInProgress(
          current: current,
          pendingProps: newFiber.pendingProps
        )
        workInProgress.type = newFiber.type
        workInProgress.lanes = lane
      } else {
        // Different type/key - mark old for deletion and create new
        current.flags.insert(.deletion)
        deletions.append(current)

        workInProgress = createFiberFromNew(newFiber, lane: lane)
        workInProgress.flags.insert(.placement)
      }
    } else {
      // No current fiber - this is a new node
      workInProgress = createFiberFromNew(newFiber, lane: lane)
      workInProgress.flags.insert(.placement)
    }

    // Copy properties from new fiber
    workInProgress.sourceNode = newFiber.sourceNode
    workInProgress.textContent = newFiber.textContent
    workInProgress.events = newFiber.events

    // Determine if we need an update
    if let current = current, workInProgress.flags.contains(.placement) == false {
      if propsChanged(current: current, new: workInProgress) ||
         textChanged(current: current, new: workInProgress) ||
         eventsChanged(current: current, new: workInProgress) {
        workInProgress.flags.insert(.update)
      }
    }

    // Reconcile children
    reconcileChildren(
      workInProgress: workInProgress,
      currentChild: current?.child,
      newChild: newFiber.child,
      lane: lane
    )

    return workInProgress
  }

  // MARK: - Reconcile Children

  /// Reconcile the children of a fiber (the diff algorithm)
  private func reconcileChildren(
    workInProgress: Fiber,
    currentChild: Fiber?,
    newChild: Fiber?,
    lane: Lane
  ) {
    // No new children - delete all old children
    guard let newChild = newChild else {
      if let currentChild = currentChild {
        deleteRemainingChildren(currentChild)
      }
      return
    }

    reconcileChildrenWithoutKeys(
      workInProgress: workInProgress,
      currentChild: currentChild,
      newChild: newChild,
      lane: lane
    )
  }

  // MARK: - Reconcile Children Without Keys

  /// Reconcile children without keys (positional matching)
  private func reconcileChildrenWithoutKeys(
    workInProgress: Fiber,
    currentChild: Fiber?,
    newChild: Fiber?,
    lane: Lane
  ) {
    var oldFiber = currentChild
    var newFiber = newChild
    var previousNewFiber: Fiber?
    var lastPlacedIndex = 0

    // Phase 1: Match children in order
    while oldFiber != nil && newFiber != nil {
      let current = oldFiber!
      let new = newFiber!

      let reconciled: Fiber

      if canReuse(current: current, new: new) {
        // Can reuse - reconcile with existing fiber
        reconciled = reconcileFiber(current: current, newFiber: new, lane: lane)
        lastPlacedIndex = current.index
      } else {
        // Can't reuse - mark for deletion and create new
        current.flags.insert(.deletion)
        deletions.append(current)

        reconciled = reconcileFiber(current: nil, newFiber: new, lane: lane)
      }

      reconciled.index = lastPlacedIndex
      reconciled.parent = workInProgress

      // Link siblings
      if previousNewFiber == nil {
        workInProgress.child = reconciled
      } else {
        previousNewFiber?.sibling = reconciled
      }
      previousNewFiber = reconciled

      oldFiber = oldFiber?.sibling
      newFiber = newFiber?.sibling
      lastPlacedIndex += 1
    }

    // Phase 2: New children remain - insert them
    while newFiber != nil {
      let new = newFiber!
      let reconciled = reconcileFiber(current: nil, newFiber: new, lane: lane)
      reconciled.index = lastPlacedIndex
      reconciled.parent = workInProgress

      if previousNewFiber == nil {
        workInProgress.child = reconciled
      } else {
        previousNewFiber?.sibling = reconciled
      }
      previousNewFiber = reconciled

      newFiber = newFiber?.sibling
      lastPlacedIndex += 1
    }

    // Phase 3: Old children remain - delete them
    if oldFiber != nil {
      deleteRemainingChildren(oldFiber!)
    }
  }

  // MARK: - Helper Functions

  /// Check if a fiber can be reused (same type and key)
  private func canReuse(current: Fiber, new: Fiber) -> Bool {
    // Type must match
    guard current.type == new.type else { return false }

    // Key must match
    switch (current.key, new.key) {
    case (nil, nil):
      return true
    case let (c?, n?):
      return c == n
    default:
      return false
    }
  }

  /// Check if props changed
  private func propsChanged(current: Fiber, new: Fiber) -> Bool {
    guard current.memoizedProps.count == new.pendingProps.count else {
      return true
    }
    return new.pendingProps.contains { current.memoizedProps[$0.key] != $0.value }
  }

  /// Check if text content changed
  private func textChanged(current: Fiber, new: Fiber) -> Bool {
    current.textContent != new.textContent
  }

  /// Check if events changed
  private func eventsChanged(current: Fiber, new: Fiber) -> Bool {
    guard current.events.count == new.events.count else { return true }
    return new.events.keys.contains { current.events[$0] == nil }
  }

  /// Create a new fiber from a template fiber
  private func createFiberFromNew(_ newFiber: Fiber, lane: Lane) -> Fiber {
    let fiber = Fiber(
      tag: newFiber.tag,
      type: newFiber.type,
      key: newFiber.key,
      pendingProps: newFiber.pendingProps,
      textContent: newFiber.textContent
    )
    fiber.lanes = lane
    return fiber
  }

  /// Delete all remaining children
  private func deleteRemainingChildren(_ fiber: Fiber) {
    var current: Fiber? = fiber
    while let fiber = current {
      fiber.flags.insert(.deletion)
      deletions.append(fiber)
      current = fiber.sibling
    }
  }

  /// Update state references to point to reconciled fibers
  func updateStateReferences(in fiber: Fiber?) {
    guard let fiber = fiber else { return }

    // Rebind component state to the reconciled fiber
    if fiber.isComponent, let component = fiber.sourceNode as? any ComponentNode {
      component.__bindStorage(with: fiber)
    }

    // Recursively update children
    var child = fiber.child
    while let c = child {
      updateStateReferences(in: c)
      child = c.sibling
    }
  }

  /// Get collected deletions
  func getDeletions() -> [Fiber] {
    deletions
  }

  /// Clear deletions
  func clearDeletions() {
    deletions.removeAll()
  }

  /// Add a fiber to the deletions list
  func addDeletion(_ fiber: Fiber) {
    deletions.append(fiber)
  }

  /// Reconcile children for a component update (called from Renderer)
  func reconcileChildrenForComponent(
    workInProgress: Fiber,
    currentChild: Fiber?,
    newChild: Fiber?,
    lane: Lane
  ) {
    // Use the existing reconcileChildren logic
    reconcileChildren(
      workInProgress: workInProgress,
      currentChild: currentChild,
      newChild: newChild,
      lane: lane
    )
  }
}

// MARK: - Work Loop

extension Reconciler {

  /// Perform a unit of work (beginWork + completeWork pattern)
  /// This is called repeatedly until all work is done
  func performUnitOfWork(_ unitOfWork: Fiber) -> Fiber? {
    // 1. Begin work on this fiber
    let next = beginWork(unitOfWork)

    // 2. If it has a child, that's the next unit of work
    if let next = next {
      return next
    }

    // 3. No child, complete this fiber and move to sibling/parent
    return completeUnitOfWork(unitOfWork)
  }

  // MARK: - Begin Work

  /// Begin work on a fiber - process it and return the next fiber to work on
  /// This is where we decide how to process each fiber type
  private func beginWork(_ fiber: Fiber) -> Fiber? {
    switch fiber.tag {
    case .functionComponent:
      return updateFunctionComponent(fiber)

    case .hostComponent:
      return updateHostComponent(fiber)

    case .hostText:
      // Text nodes have no children
      return nil

    case .hostRoot:
      // Root just processes its children
      return fiber.child

    case .classComponent:
      // Not implemented in SwiftWeb
      return nil
    }
  }

  /// Update a function component
  private func updateFunctionComponent(_ fiber: Fiber) -> Fiber? {
    guard let component = fiber.sourceNode as? any ComponentNode else {
      return fiber.child
    }

    // Bind state to this fiber
    fiber.bindComponentState(component)

    // Get the component's content
    let content = component.content

    // Convert content to fiber
    let newChildFiber = converter.convert(content, lane: fiber.lanes)

    // Reconcile children
    reconcileChildren(
      workInProgress: fiber,
      currentChild: fiber.alternate?.child,
      newChild: newChildFiber,
      lane: fiber.lanes
    )

    return fiber.child
  }

  /// Update a host component (DOM element)
  private func updateHostComponent(_ fiber: Fiber) -> Fiber? {
    // Host components just need their children reconciled
    // (the children were already set during initial fiber creation)
    return fiber.child
  }

  // MARK: - Complete Work

  /// Complete work on a fiber and return the next fiber to work on
  /// This is where we collect effects into the effect list
  private func completeUnitOfWork(_ fiber: Fiber) -> Fiber? {
    var completedWork: Fiber? = fiber

    repeat {
      guard let work = completedWork else { break }

      // Complete this fiber
      completeWork(work)

      // Try sibling
      if let sibling = work.sibling {
        return sibling
      }

      // No sibling, go to parent
      completedWork = work.parent
    } while completedWork != nil

    // No more work
    return nil
  }

  /// Complete work for a single fiber
  /// This is where we would create DOM nodes (but we defer that to commit phase)
  private func completeWork(_ fiber: Fiber) {
    // Update memoizedProps
    fiber.memoizedProps = fiber.pendingProps

    // Collect subtree flags
    var subtreeFlags: EffectFlags = .noFlags
    var child = fiber.child
    while let c = child {
      subtreeFlags.formUnion(c.flags)
      subtreeFlags.formUnion(c.subtreeFlags)
      child = c.sibling
    }
    fiber.subtreeFlags = subtreeFlags

    // Note: In React, this is where we'd create DOM nodes for host components
    // We defer that to the commit phase in our implementation
  }
}
