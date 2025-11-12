import SwiftHTML
import JavaScriptKit
import Foundation

// MARK: - Effect Flags

/// Flags indicating what side effects need to be performed on a fiber
public struct EffectFlags: OptionSet {
  public let rawValue: UInt16

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }

  public static let noFlags: EffectFlags         = []  // No effects
  public static let placement       = EffectFlags(rawValue: 1 << 0)  // Insert into DOM
  public static let update          = EffectFlags(rawValue: 1 << 1)  // Update props/attrs
  public static let deletion        = EffectFlags(rawValue: 1 << 2)  // Remove from DOM
  public static let childDeletion   = EffectFlags(rawValue: 1 << 3)  // Has children to delete
}

// MARK: - Priority Lanes

/// Priority lanes for scheduling work (inspired by React's lane system)
public struct Lane: OptionSet {
  public let rawValue: UInt32

  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }

  public static let noLane: Lane          = []  // No lanes
  public static let syncLane        = Lane(rawValue: 1 << 0)   // 1 - Immediate sync
  public static let inputLane       = Lane(rawValue: 1 << 1)   // 2 - User input
  public static let defaultLane     = Lane(rawValue: 1 << 4)   // 16 - Normal updates
  public static let transitionLane  = Lane(rawValue: 1 << 6)   // 64 - Low priority
  public static let idleLane        = Lane(rawValue: 1 << 30)  // Very low priority

  /// Check if this lane is higher priority than another
  public func isHigherPriorityThan(_ other: Lane) -> Bool {
    // Lower bit position = higher priority
    guard rawValue != 0, other.rawValue != 0 else { return false }
    return rawValue.trailingZeroBitCount < other.rawValue.trailingZeroBitCount
  }
}

// MARK: - Fiber Node Tags

/// Type of fiber node
enum FiberTag {
  case hostRoot           // Root of the fiber tree
  case hostComponent      // DOM element (div, span, etc.)
  case hostText           // Text node
  case functionComponent  // Function component
  case classComponent     // Class component (not used in SwiftWeb)
}

// MARK: - Fiber Node

/// A fiber represents a unit of work and a node in the React-like virtual tree
final class Fiber {

  // MARK: - Identity

  /// Type of this fiber (component, element, text, etc.)
  let tag: FiberTag

  /// Unique key for reconciliation (for lists)
  var key: AnyHashable?

  /// Type of the element (for components)
  var elementType: (any Node.Type)?

  /// Resolved type (same as elementType for now)
  var type: String

  /// Reference to the actual DOM node (for host components/text)
  var stateNode: JSObject?

  // MARK: - Tree Structure (Linked List)

  /// Parent fiber (where we "return" after completing this work)
  weak var parent: Fiber?

  /// First child fiber
  var child: Fiber?

  /// Next sibling fiber
  var sibling: Fiber?

  /// Index among siblings
  var index: Int = 0

  // MARK: - Props and State

  /// New props being worked on
  var pendingProps: [String: String]

  /// Props from the last completed render
  var memoizedProps: [String: String]

  /// Text content (for text nodes)
  var textContent: String?

  /// Component state storage
  var states: [String: Any] = [:]

  /// Reference to the source Node that created this fiber
  var sourceNode: (any Node)?

  // MARK: - Effects and Updates

  /// What effects need to be applied to this fiber
  var flags: EffectFlags = .noFlags

  /// Effect flags from the subtree
  var subtreeFlags: EffectFlags = .noFlags

  /// Children marked for deletion
  var deletions: [Fiber]?

  /// Event handlers attached to this fiber
  var events: [String: EventHandler] = [:]

  // MARK: - Effect List (Linked List of Effects)

  /// First fiber with effects in subtree
  var firstEffect: Fiber?

  /// Last fiber with effects in subtree
  var lastEffect: Fiber?

  /// Next fiber in the effect list
  var nextEffect: Fiber?

  // MARK: - Scheduling

  /// Priority lanes for this fiber's work
  var lanes: Lane = .noLane

  /// Priority lanes needed by children
  var childLanes: Lane = .noLane

  // MARK: - Double Buffering

  /// The alternate fiber (current ↔ work-in-progress)
  var alternate: Fiber?

  // MARK: - Initialization

  init(
    tag: FiberTag,
    type: String,
    key: AnyHashable? = nil,
    pendingProps: [String: String] = [:],
    textContent: String? = nil
  ) {
    self.tag = tag
    self.type = type
    self.key = key
    self.pendingProps = pendingProps
    self.memoizedProps = [:]
    self.textContent = textContent
  }

  @MainActor deinit {
    // Break sibling chain iteratively to avoid recursive deallocation
    // This prevents stack overflow with long sibling chains (e.g., 1000+ items)
    var current = sibling
    sibling = nil

    while let fiber = current {
      let next = fiber.sibling
      fiber.sibling = nil
      current = next
    }
  }

  // MARK: - Helpers

  /// Check if this is a text node
  var isTextNode: Bool {
    tag == .hostText
  }

  /// Check if this is a component (not a host element)
  var isComponent: Bool {
    tag == .functionComponent || tag == .classComponent
  }

  /// Check if this is a host element (DOM element)
  var isHostComponent: Bool {
    tag == .hostComponent
  }

  /// Bind component state storage (bridge to old system)
  func bindComponentState(_ component: any ComponentNode) {
    // Store reference to component for state management
    // This allows components to access their state through this fiber
  }
}

extension Fiber: StateBindable {
  public func bind<T>(stateName: String, to state: State<T>) {
    state.box.stateName = stateName
    state.box.fiber = self

    if states[stateName] == nil {
      // Initialize with the state's initial value if not present
      states[stateName] = state.box.initialValue
    }
  }
}

// MARK: - Fiber Creation Helpers

extension Fiber {

  /// Create a work-in-progress fiber from a current fiber
  static func createWorkInProgress(
    current: Fiber,
    pendingProps: [String: String]
  ) -> Fiber {
    var workInProgress = current.alternate

    if workInProgress == nil {
      // First time: create a new fiber
      workInProgress = Fiber(
        tag: current.tag,
        type: current.type,
        key: current.key,
        pendingProps: pendingProps
      )
      workInProgress!.elementType = current.elementType
      workInProgress!.stateNode = current.stateNode
      workInProgress!.alternate = current
      current.alternate = workInProgress
    } else {
      // Reuse existing work-in-progress fiber
      workInProgress!.pendingProps = pendingProps
      workInProgress!.flags = .noFlags
      workInProgress!.subtreeFlags = .noFlags
      workInProgress!.deletions = nil
      workInProgress!.nextEffect = nil
    }

    // Copy from current
    workInProgress!.child = current.child
    workInProgress!.memoizedProps = current.memoizedProps
    workInProgress!.states = current.states
    workInProgress!.sourceNode = current.sourceNode
    workInProgress!.lanes = current.lanes
    workInProgress!.childLanes = current.childLanes

    return workInProgress!
  }

  /// Create a fiber from a Node
  static func createFiberFromElement(
    _ element: some Node,
    lane: Lane
  ) -> Fiber? {
    // This will be implemented by the FiberConverter
    return nil
  }
}

// MARK: - Debug Description

extension Fiber: CustomStringConvertible {
  public var description: String {
    var desc = "Fiber(\(tag), type: \(type)"
    if let key = key {
      desc += ", key: \(key)"
    }
    if flags != .noFlags {
      desc += ", flags: \(flags)"
    }
    desc += ")"
    return desc
  }
}

typealias EventHandler = (sending JSValue) -> Void
