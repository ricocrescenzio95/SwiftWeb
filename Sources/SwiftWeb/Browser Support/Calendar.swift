import Foundation

extension Calendar {
  public static let browser: Calendar = {
    #if arch(wasm32)
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .browser
    calendar.timeZone = .browser
    return calendar
    #else
    .current
    #endif
  }()
}
