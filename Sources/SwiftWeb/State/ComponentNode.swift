import SwiftHTML

public protocol ComponentNode: Node {
  func __bindStorage(with bindable: some StateBindable)

  @HTMLBuilder
  nonisolated var content: Content { get }
}
