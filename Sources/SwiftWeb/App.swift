public import SwiftHTML
import JavaScriptKit

public protocol App: @MainActor Node {
  static func main()
  init()
}

public extension App {
  static func main() {
    let renderer = TreeRenderer()
    renderer.start(app: Self())
  }
}
