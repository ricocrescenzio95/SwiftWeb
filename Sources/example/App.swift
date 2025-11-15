import SwiftWeb
import JavaScriptKit

@main
@Component
struct TestApp: App {
  @State var isVisible: Bool = false
  @State var items: [Int] = (1...5).map(\.self)
  @State var text: String = "hello"
  
  var content: some Node {
    head {
      title { "V2 Renderer Test" }
      style {
        "body"(
          .fontFamily("system-ui"),
          .padding(40),
          .maxWidth(800),
          .margin(.init(vertical: 0, horizontal: .auto))
        )
        "h1"(
          .color(.hex("#007AFF"))
        )
        ".box"(
          .backgroundColor(.hex("#F5F5F5")),
          .padding(20),
          .borderRadius(8),
          .margin(.init(vertical: 20, horizontal: .zero))
        )
        "button"(
          .padding(.init(vertical: 10, horizontal: 20)),
          .margin(5),
          .backgroundColor(.hex("#007AFF")),
          .color(.white),
          .border("none"),
          .borderRadius(4),
          .cursor(.pointer)
        )
      }
    }
    body(.class("flex flex-col gap-4")) {
      h1(.class("text-4xl")) { "🧪 V2 Renderer Test" }
      input(.value(text), .class("border p-2 rounded"))
        .onInput { event in
          text = event.target.value ?? ""
        }

      div(.class("box")) {
        h2 { "Static Content" }
        p { "If you see this, basic rendering works! ✅" }
      }
      
      div(.class("box")) {
        h2 { "Event Handler Test" }
        CounterView()
        button { "Test Click" }
          .onClick {
            print("🎉 Event handler works!")
            // Show alert
            _ = JSObject.global.alert!("Event handler works!")
          }
        button { isVisible ? "Hide" : "Show" }
          .onClick {
            isVisible.toggle()
          }
        button { "Remove" }
          .onClick {
            if !items.isEmpty {
              items.removeFirst()
            }
          }
        if isVisible {
          button { "Add" }
            .onClick {
              if items.isEmpty {
                items.append(1)
              } else {
                items.insert(items.max()! + 1, at: 0)
              }
            }
        }
        button(
          .style(isVisible ? [
            .backgroundColor(.aqua),
            .color(.black)
          ] : [])
        ) { "Shuffle" }
          .onClick {
            items.shuffle()
          }
      }
      
      if isVisible {
        div(.class("box")) {
          p { "VISIBLE" }
        }
      }
      
      a(.href("https://www.google.com"), .target(._blank)) {
        "Open google"
      }
      
      div(.class("box")) {
        h2 { "List with Keys (\(items.count) items)" }
        ul {
          forEach(items, id: \.self) { item in
            li { "Item #\(item)" }
          }
        }
      }
    }
  }
}

@Component
struct CounterView {
  @State var count: Int = 0
  
  @HTMLBuilder
  var content: some Node {
    
    button { "-" }
      .onClick {
        count -= 1
      }
    "Count: \(count)"
    button { "+" }
      .onClick {
        count += 1
      }
    
  }
}
