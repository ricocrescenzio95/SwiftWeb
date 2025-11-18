public import SwiftHTML
import JavaScriptKit
import Foundation

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

public let navigator = JSObject.global.navigator.object!

extension Locale {
  #if arch(wasm32)
  public static var browser: Locale = .init(identifier: navigator.language.string ?? "en-US")
  #else
  public static let browser: Locale = .current
  #endif
}
extension TimeZone {
  #if arch(wasm32)
  public static let browser: TimeZone = .init(identifier: JSObject.global.Intl.object!.DateTimeFormat.function!.new().resolvedOptions!().timeZone.string ?? "UTC")!
  #else
  public static let browser: TimeZone = .current
  #endif
}
extension Calendar {
  #if arch(wasm32)
  public static let browser: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .browser
    calendar.timeZone = .browser
    return calendar
  }()
  #else
  public static let browser: Calendar = .current
  #endif
}
