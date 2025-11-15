import SwiftHTML
import JavaScriptKit
import Foundation

// MARK: - Root Container

/// Root container holding the fiber tree
final class FiberRoot {
  /// Current tree (what's rendered on screen)
  var current: Fiber?

  /// Work-in-progress tree (being built)
  var workInProgress: Fiber?

  /// Pending work lanes
  var pendingLanes: Lane = .noLane

  /// Priority of scheduled callback
  var callbackPriority: Lane = .noLane

  init() {}
}

// MARK: - Renderer

/// The main renderer coordinating the entire reconciliation and commit process
/// This implements the React Fiber architecture in Swift
public final class Renderer {

  // MARK: - Properties

  /// The root of our fiber tree
  private var root: FiberRoot

  /// The reconciler (handles the render phase)
  private(set) var reconciler = Reconciler()
  
  /// The event handler
  private(set) lazy var domEvents = DOMEvents()

  /// The commit phase handler
  private(set) lazy var commitPhase = CommitPhase(domEvents: domEvents)

  /// Current work-in-progress fiber (during work loop)
  private var workInProgress: Fiber?

  /// Time when the current work started (for time slicing)
  private var workStartTime: Date?

  /// Frame budget in milliseconds (how long we can work before yielding)
  private let frameBudget: TimeInterval = 5.0 / 1000.0  // 5ms

  /// Reference to the app for re-rendering
  private var currentApp: (any App)?

  // MARK: - Initialization

  public init() {
    self.root = FiberRoot()
  }

  // MARK: - Main Entry Points

  /// Start rendering an app
  public func start(app: some App) {
    // Store app for re-rendering
    currentApp = app

    // Create initial root fiber if needed
    if root.current == nil {
      let rootFiber = Fiber(tag: .hostRoot, type: "root")
      root.current = rootFiber
    }

    // Convert app to fiber tree and attach as child of root
    guard reconciler.converter.convert(app, lane: .syncLane) != nil else {
      return
    }

    // Reconcile with current tree
    let workInProgress = reconciler.reconcile(
      current: root.current,
      newElement: app,
      lane: .syncLane
    )

    guard let finishedWork = workInProgress else {
      return
    }

    // Commit immediately (sync lane)
    let deletions = reconciler.getDeletions()
    commitPhase.commitRoot(finishedWork, deletions: deletions)
    reconciler.clearDeletions()

    // Update current
    root.current = finishedWork
  }

  // TODO: MUST FIX
  /// Trigger a re-render when state changes
  /// Re-renders starting from the component that owns the changed state
  func scheduleStateUpdate(from fiber: Fiber) {
    print("🔄 [State Update] Starting component re-render from fiber: \(fiber.type)")

    // Find the component fiber (the fiber passed should be the component itself)
    guard fiber.isComponent else {
      print("❌ [State Update] Fiber is not a component")
      return
    }

    // Get the component from the fiber
    guard let component = fiber.sourceNode as? any ComponentNode else {
      print("❌ [State Update] Fiber has no component sourceNode")
      return
    }

    // Re-bind state to ensure it reads the updated values
    component.__bindStorage(with: fiber)

    // Regenerate the component's content with the NEW state
    print("🔄 [State Update] Regenerating component content...")
    let newContent = component.content

    // Convert to fiber tree
    guard let newTree = reconciler.converter.convert(newContent, lane: .defaultLane) else {
      print("❌ [State Update] Failed to convert")
      return
    }

    // Get the current fiber's old children
    let oldChild = fiber.child

    // Reconcile the component's children
    print("🔄 [State Update] Reconciling component children...")
    reconciler.reconcileChildrenForComponent(
      workInProgress: fiber,
      currentChild: oldChild,
      newChild: newTree,
      lane: .defaultLane
    )

    // Update state references in the reconciled subtree
    reconciler.updateStateReferences(in: fiber)

    // Commit the changes
    print("🔄 [State Update] Committing changes...")
    let deletions = reconciler.getDeletions()
    commitPhase.commitRoot(fiber, deletions: deletions)
    reconciler.clearDeletions()

    print("✅ [State Update] Complete")
  }

  /// Find the nearest component fiber by walking up the tree
  private func findComponentFiber(from fiber: Fiber) -> Fiber? {
    var current: Fiber? = fiber

    while let f = current {
      if f.isComponent {
        return f
      }
      current = f.parent
    }

    return nil
  }

  /// Reconcile a component's children (similar to reconciler but for a subtree)
  private func reconcileComponentChildren(
    parent: Fiber,
    oldChild: Fiber?,
    newChild: Fiber,
    lane: Lane
  ) -> Fiber? {
    // Simple reconciliation for component re-render
    // Compare old and new child trees

    // If types match, we can try to reuse
    if let old = oldChild, old.type == newChild.type && old.key == newChild.key {
      // Create work-in-progress from current
      let wip = Fiber.createWorkInProgress(
        current: old,
        pendingProps: newChild.pendingProps
      )
      wip.type = newChild.type
      wip.lanes = lane
      wip.sourceNode = newChild.sourceNode
      wip.textContent = newChild.textContent
      wip.events = newChild.events

      // Check if update is needed
      if old.pendingProps != newChild.pendingProps ||
         old.textContent != newChild.textContent ||
         old.events.keys != newChild.events.keys {
        wip.flags.insert(.update)
      }

      // Recursively reconcile children
      reconcileSubtree(wip: wip, old: old, new: newChild, lane: lane)

      return wip
    } else {
      // Different types - mark old for deletion and return new
      if let old = oldChild {
        old.flags.insert(.deletion)
        reconciler.addDeletion(old)
      }

      // Mark new fiber for placement
      newChild.flags.insert(.placement)
      newChild.lanes = lane

      // Recursively mark all children for placement
      var child = newChild.child
      while let c = child {
        c.flags.insert(.placement)
        child = c.sibling
      }

      return newChild
    }
  }

  /// Recursively reconcile a subtree
  private func reconcileSubtree(wip: Fiber, old: Fiber, new: Fiber, lane: Lane) {
    // Reconcile children
    var oldChild = old.child
    var newChild = new.child

    var prevWipChild: Fiber?

    while newChild != nil || oldChild != nil {
      let reconciledChild: Fiber?

      if let newC = newChild, let oldC = oldChild,
         newC.type == oldC.type && newC.key == oldC.key {
        // Reuse
        let wipChild = Fiber.createWorkInProgress(
          current: oldC,
          pendingProps: newC.pendingProps
        )
        wipChild.type = newC.type
        wipChild.lanes = lane
        wipChild.sourceNode = newC.sourceNode
        wipChild.textContent = newC.textContent
        wipChild.events = newC.events
        wipChild.parent = wip

        if oldC.pendingProps != newC.pendingProps ||
           oldC.textContent != newC.textContent {
          wipChild.flags.insert(.update)
        }

        reconcileSubtree(wip: wipChild, old: oldC, new: newC, lane: lane)
        reconciledChild = wipChild

        oldChild = oldC.sibling
        newChild = newC.sibling

      } else if let newC = newChild {
        // New child - mark for placement
        newC.flags.insert(.placement)
        newC.lanes = lane
        newC.parent = wip
        reconciledChild = newC
        newChild = newC.sibling

      } else if let oldC = oldChild {
        // Old child removed - mark for deletion
        oldC.flags.insert(.deletion)
        reconciler.addDeletion(oldC)
        reconciledChild = nil
        oldChild = oldC.sibling
      } else {
        reconciledChild = nil
      }

      // Link siblings
      if let child = reconciledChild {
        if prevWipChild == nil {
          wip.child = child
        } else {
          prevWipChild?.sibling = child
        }
        prevWipChild = child
      }
    }
  }

  /// Internal method to render the app
  private func renderApp(_ app: any App) {
    // Convert app to fiber tree
    guard reconciler.converter.convert(app, lane: .defaultLane) != nil else {
      return
    }

    // Reconcile with current tree
    let workInProgress = reconciler.reconcile(
      current: root.current,
      newElement: app,
      lane: .defaultLane
    )

    guard let finishedWork = workInProgress else {
      return
    }

    // Commit the changes
    let deletions = reconciler.getDeletions()
    commitPhase.commitRoot(finishedWork, deletions: deletions)
    reconciler.clearDeletions()

    // Update current
    root.current = finishedWork
  }

  // MARK: - Scheduling

  /// Schedule an update with a specific priority lane
  private func scheduleUpdateOnFiber(newElement: some Node, lane: Lane) {
    // Mark that we have pending work
    root.pendingLanes.formUnion(lane)

    // Ensure root is scheduled
    ensureRootIsScheduled(lane: lane)
  }

  /// Ensure the root is scheduled for work
  private func ensureRootIsScheduled(lane: Lane) {
    // Get the highest priority pending work
    let nextLanes = getNextLanes()

    guard nextLanes != .noLane else {
      // No work to do
      return
    }

    // Determine priority
    let newCallbackPriority = getHighestPriorityLane(nextLanes)

    // If already scheduled with same priority, skip
    if newCallbackPriority == root.callbackPriority {
      return
    }

    // Update callback priority
    root.callbackPriority = newCallbackPriority

    // Schedule based on priority
    if newCallbackPriority == .syncLane {
      // Synchronous - execute immediately
      performSyncWorkOnRoot()
    } else {
      // Concurrent - schedule for later
      performConcurrentWorkOnRoot()
    }
  }

  /// Get the next lanes to work on
  private func getNextLanes() -> Lane {
    root.pendingLanes
  }

  /// Get the highest priority lane from a set of lanes
  private func getHighestPriorityLane(_ lanes: Lane) -> Lane {
    // Find the lowest set bit (highest priority)
    let raw = lanes.rawValue
    guard raw != 0 else { return .noLane }

    let lowestBit = raw & (~raw + 1)
    return Lane(rawValue: lowestBit)
  }

  // MARK: - Work Loop (Synchronous)

  /// Perform synchronous work on the root
  private func performSyncWorkOnRoot() {
    let lanes = getNextLanes()
    guard lanes != .noLane else { return }

    // Start render phase (synchronous)
    renderRootSync(lanes: lanes)

    // Get the finished work
    guard let finishedWork = root.workInProgress else { return }

    // Commit the work
    commitRoot(finishedWork, lanes: lanes)
  }

  /// Render the root synchronously (cannot be interrupted)
  private func renderRootSync(lanes: Lane) {
    // Prepare work
    prepareFreshStack(lanes: lanes)

    // Work loop - process all work without interruption
    while workInProgress != nil {
      performUnitOfWork(workInProgress!)
    }
  }

  // MARK: - Work Loop (Concurrent)

  /// Perform concurrent work on the root (can be interrupted)
  private func performConcurrentWorkOnRoot() {
    let lanes = getNextLanes()
    guard lanes != .noLane else { return }

    // Start render phase (concurrent)
    renderRootConcurrent(lanes: lanes)

    // Get the finished work
    guard let finishedWork = root.workInProgress else { return }

    // Commit the work
    commitRoot(finishedWork, lanes: lanes)
  }

  /// Render the root concurrently (can be interrupted)
  private func renderRootConcurrent(lanes: Lane) {
    // Prepare work
    prepareFreshStack(lanes: lanes)

    workStartTime = Date()

    // Work loop - process work until done or need to yield
    while workInProgress != nil && !shouldYield() {
      performUnitOfWork(workInProgress!)
    }

    // If we still have work, schedule continuation
    if workInProgress != nil {
      // More work to do - would normally schedule via requestIdleCallback
      // For now, just continue synchronously
      renderRootConcurrent(lanes: lanes)
    }
  }

  /// Check if we should yield to the browser
  private func shouldYield() -> Bool {
    guard let startTime = workStartTime else { return false }

    let elapsed = Date().timeIntervalSince(startTime)

    // Yield if we've exceeded our frame budget
    return elapsed >= frameBudget
  }

  // MARK: - Work Units

  /// Prepare a fresh stack for new work
  private func prepareFreshStack(lanes: Lane) {
    // Get the current root fiber or create one
    if root.current == nil {
      // Create initial root fiber
      let rootFiber = Fiber(tag: .hostRoot, type: "root")
      root.current = rootFiber
    }

    // Create work-in-progress root
    root.workInProgress = Fiber.createWorkInProgress(
      current: root.current!,
      pendingProps: [:]
    )

    workInProgress = root.workInProgress
  }

  /// Perform a unit of work
  private func performUnitOfWork(_ unitOfWork: Fiber) {
    let current = unitOfWork.alternate

    // Begin work - returns next fiber to work on (child)
    let next = beginWork(current: current, workInProgress: unitOfWork)

    // Update memoized props
    unitOfWork.memoizedProps = unitOfWork.pendingProps

    if next == nil {
      // No child - complete this unit and move to sibling/parent
      completeUnitOfWork(unitOfWork)
    } else {
      // Continue with child
      workInProgress = next
    }
  }

  /// Begin work on a fiber
  private func beginWork(current: Fiber?, workInProgress: Fiber) -> Fiber? {
    return reconciler.performUnitOfWork(workInProgress)
  }

  /// Complete a unit of work
  private func completeUnitOfWork(_ unitOfWork: Fiber) {
    var completedWork: Fiber? = unitOfWork

    repeat {
      guard let work = completedWork else { break }

      let returnFiber = work.parent

      // Complete this fiber
      completeWork(work)

      // Try sibling
      if let sibling = work.sibling {
        workInProgress = sibling
        return
      }

      // No sibling - complete parent
      completedWork = returnFiber
      workInProgress = completedWork
    } while completedWork != nil
  }

  /// Complete work on a fiber
  private func completeWork(_ fiber: Fiber) {
    // Update memoized props
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
  }

  // MARK: - Commit Phase

  /// Commit the finished work to the DOM
  private func commitRoot(_ finishedWork: Fiber, lanes: Lane) {
    // Get deletions from reconciler
    let deletions = reconciler.getDeletions()

    // Commit all effects
    commitPhase.commitRoot(finishedWork, deletions: deletions)

    // Clear deletions
    reconciler.clearDeletions()

    // Swap current and work-in-progress (double buffering!)
    root.current = finishedWork
    root.workInProgress = nil

    // Clear completed lanes
    root.pendingLanes.subtract(lanes)
    root.callbackPriority = .noLane

    // If there's more work, schedule it
    let nextLanes = getNextLanes()
    if nextLanes != .noLane {
      ensureRootIsScheduled(lane: getHighestPriorityLane(nextLanes))
    }
  }

  // MARK: - Public API for Updates

  /// Schedule an update with specific priority
  func scheduleUpdate(_ newElement: some Node, priority: Lane = .defaultLane) {
    scheduleUpdateOnFiber(newElement: newElement, lane: priority)
  }

  /// Schedule a high-priority update (e.g., from user input)
  public func scheduleInputUpdate(_ newElement: some Node) {
    scheduleUpdateOnFiber(newElement: newElement, lane: .inputLane)
  }

  /// Schedule a low-priority update (e.g., data fetching)
  public func scheduleTransitionUpdate(_ newElement: some Node) {
    scheduleUpdateOnFiber(newElement: newElement, lane: .transitionLane)
  }
}

// MARK: - Global Instance

/// Global renderer instance
public private(set) var renderer: Renderer?

/// Initialize the renderer
public func initRenderer() {
  renderer = Renderer()
}

// MARK: - App Extension

extension App {
  /// Start the app using Renderer
  public static func start() {
    if renderer == nil {
      initRenderer()
      renderer?.start(app: Self())
    }
  }
}
