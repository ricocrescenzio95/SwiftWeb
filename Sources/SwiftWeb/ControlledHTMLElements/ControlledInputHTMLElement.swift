import SwiftHTML
import Foundation

public struct ControlledInputHTMLElement: Node {
  public static var name: String { InputHTMLElement.name }
  public var attributes: [HTMLAttribute<InputHTMLAttribute>]
  var inputType: InputType
  @Binding var value: String
  
  public var content: some Node {
    input(attributes + [.value(value), .type(inputType)])
      .onInput {
        value = $0.target.value ?? ""
      }
  }
}

public func input(text: Binding<String>, _ attributes: [HTMLAttribute<InputHTMLAttribute>]) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .text, value: text)
}
public func input(text: Binding<String>, _ attributes: HTMLAttribute<InputHTMLAttribute>...) -> ControlledInputHTMLElement {
  input(text: text, attributes)
}

private let onlyDateFormatter = Date.VerbatimFormatStyle(
  format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
  locale: .browser,
  timeZone: .browser,
  calendar: .browser
)

public func input(
  date: Binding<Date?>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .date,
    value: .init(
      get: { 
        guard let d = date.get() else { return "" }
        return onlyDateFormatter.format(d)
      },
      set: { 
        do {
          date.set(try onlyDateFormatter.parseStrategy.parse($0))
        } catch {
          print(error)
        }
      }
    )
  )
}

public func input(
  date: Binding<Date?>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(date: date, attributes)
}

private let localDateTimeFormatter = Date.VerbatimFormatStyle(
  format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)",
  locale: .browser,
  timeZone: .browser,
  calendar: .browser
)

public func input(
  dateTime: Binding<Date?>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .datetimeLocal,
    value: .init(
      get: {
        guard let dt = dateTime.get() else { return "" }
        return localDateTimeFormatter.format(dt)
      },
      set: { 
        if $0.isEmpty {
          dateTime.set(nil)
        } else {
          do {
            dateTime.set(try localDateTimeFormatter.parseStrategy.parse($0))
          } catch {
            print(error)
          }
        }
      }
    )
  )
}

public func input(
  dateTime: Binding<Date?>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(dateTime: dateTime, attributes)
}

// MARK: - Email Input

public func input(
  email: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .email, value: email)
}

public func input(
  email: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(email: email, attributes)
}

// MARK: - Password Input

public func input(
  password: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .password, value: password)
}

public func input(
  password: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(password: password, attributes)
}

// MARK: - Search Input

public func input(
  search: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .search, value: search)
}

public func input(
  search: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(search: search, attributes)
}

// MARK: - Tel Input

public func input(
  tel: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .tel, value: tel)
}

public func input(
  tel: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(tel: tel, attributes)
}

// MARK: - URL Input

public func input(
  url: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .url, value: url)
}

public func input(
  url: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(url: url, attributes)
}

// MARK: - Number Input

public func input(
  number: Binding<Double>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .number,
    value: .init(
      get: { String(number.get()) },
      set: { if let num = Double($0) { number.set(num) } }
    )
  )
}

public func input(
  number: Binding<Double>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(number: number, attributes)
}

public func input(
  number: Binding<Int>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .number,
    value: .init(
      get: { String(number.get()) },
      set: { if let num = Int($0) { number.set(num) } }
    )
  )
}

public func input(
  number: Binding<Int>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(number: number, attributes)
}

// MARK: - Range Input

public func input(
  range: Binding<Double>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .range,
    value: .init(
      get: { String(range.get()) },
      set: { if let num = Double($0) { range.set(num) } }
    )
  )
}

public func input(
  range: Binding<Double>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(range: range, attributes)
}

public func input(
  range: Binding<Int>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .range,
    value: .init(
      get: { String(range.get()) },
      set: { if let num = Int($0) { range.set(num) } }
    )
  )
}

public func input(
  range: Binding<Int>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(range: range, attributes)
}

// MARK: - Color Input

public func input(
  color: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .color, value: color)
}

public func input(
  color: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(color: color, attributes)
}

// MARK: - Month Input

private let monthFormatter = Date.VerbatimFormatStyle(
  format: "\(year: .defaultDigits)-\(month: .twoDigits)",
  locale: .browser,
  timeZone: .browser,
  calendar: .browser
)

public func input(
  month: Binding<Date?>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .month,
    value: .init(
      get: { 
        guard let m = month.get() else { return "" }
        return monthFormatter.format(m)
      },
      set: { 
        if $0.isEmpty {
          month.set(nil)
        } else {
          month.set(try? monthFormatter.parseStrategy.parse($0))
        }
      }
    )
  )
}

public func input(
  month: Binding<Date?>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(month: month, attributes)
}

// MARK: - Week Input

private let weekFormatter = Date.VerbatimFormatStyle(
  format: "\(year: .defaultDigits)-'W'\(week: .twoDigits)",
  locale: .browser,
  timeZone: .browser,
  calendar: .browser
)

public func input(
  week: Binding<Date?>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .week,
    value: .init(
      get: { 
        guard let w = week.get() else { return "" }
        return weekFormatter.format(w)
      },
      set: { 
        if $0.isEmpty {
          week.set(nil)
        } else {
          week.set(try? weekFormatter.parseStrategy.parse($0))
        }
      }
    )
  )
}

public func input(
  week: Binding<Date?>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(week: week, attributes)
}

// MARK: - Time Input

private let timeFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "HH:mm"
  return formatter
}()

public func input(
  time: Binding<Date?>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(
    attributes: attributes,
    inputType: .time,
    value: .init(
      get: { 
        guard let t = time.get() else { return "" }
        return timeFormatter.string(for: t) ?? ""
      },
      set: { 
        if $0.isEmpty {
          time.set(nil)
        } else {
          time.set(timeFormatter.date(from: $0))
        }
      }
    )
  )
}

public func input(
  time: Binding<Date?>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(time: time, attributes)
}

// MARK: - File Input

public func input(
  file: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .file, value: file)
}

public func input(
  file: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(file: file, attributes)
}

// MARK: - Hidden Input

public func input(
  hidden: Binding<String>,
  _ attributes: [HTMLAttribute<InputHTMLAttribute>]
) -> ControlledInputHTMLElement {
  .init(attributes: attributes, inputType: .hidden, value: hidden)
}

public func input(
  hidden: Binding<String>,
  _ attributes: HTMLAttribute<InputHTMLAttribute>...
) -> ControlledInputHTMLElement {
  input(hidden: hidden, attributes)
}
