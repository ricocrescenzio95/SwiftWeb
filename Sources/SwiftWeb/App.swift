public import SwiftHTML

public protocol App: @MainActor Node {
  static func main()
  init()
}

public extension App {
  static func main() {
    if renderer == nil {
      initRenderer()
      renderer?.start(app: Self())
    }
  }
}
