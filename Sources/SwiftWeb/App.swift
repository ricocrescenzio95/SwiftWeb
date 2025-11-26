public import SwiftHTML

public protocol App: @MainActor Node {
  associatedtype Routes: Node
  associatedtype NotFound: Node
  static func main()
  static func __page(for route: String, context: Router.Context) -> Routes
  
  @HTMLBuilder
  static var notFound: NotFound { get }
  
  init()
}

public extension App {
  static func main() {
    if renderer == nil {
      initRenderer(app: Self.self)
    }
  }
  
  static var notFound: some Node { "404 - Not Found" }
}
