import Foundation
import JavaScriptKit

extension TimeZone {
  public static let browser: TimeZone = {
    #if arch(wasm32)
    .init(
      identifier: JSObject
        .global.Intl.object!
        .DateTimeFormat.function!.new()
        .resolvedOptions!()
        .timeZone.string ?? "UTC"
    )!
    #else
    .current
    #endif
  }()
}
