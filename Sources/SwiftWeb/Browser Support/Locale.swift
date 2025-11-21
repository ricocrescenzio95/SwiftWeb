import Foundation
import JavaScriptKit

extension Locale {
  public static let browser: Locale = {
    #if arch(wasm32)
    .init(identifier: JSObject.global.navigator.object!.language.string ?? "en-US")
    #else
    .current
    #endif
  }()
}
