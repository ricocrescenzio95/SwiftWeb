import SwiftWeb
import JavaScriptKit

@main
@Component
struct TestApp: App {
  @State var isVisible: Bool = false
  @State var items: [Int] = (1...5).map(\.self)
  
  var content: some Node {
    html {
      head {
        meta(.charset("utf-8"))
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
      body {
        h1 { "🧪 V2 Renderer Test" }
        
        div(.class("box")) {
          h2 { "Static Content" }
          p { "Se vedi questo, il rendering base funziona! ✅" }
        }
        
        div(.class("box")) {
          h2 { "Event Handler Test" }
          CounterView()
          button { "Test Click" }
            .onClick {
              print("🎉 Event handler funziona!")
              // Mostra alert
              _ = JSObject.global.alert!("Event handler funziona!")
            }
          button { isVisible ? "Nascondi" : "Mostra" }
            .onClick {
              isVisible.toggle()
            }
          button { "Rimuovi" }
            .onClick {
              if !items.isEmpty {
                items.removeFirst()
              }
            }
          button { "Aggiungi" }
            .onClick {
              if items.isEmpty {
                items.append(1)
              } else {
                items.insert(items.max()! + 1, at: 0)
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
            p { "VISIBILE" }
          }
        }
        
        div(.class("box")) {
          h2 { "Lista con Key (\(items.count) items)" }
          ul {
            ForEach(items, id: \.self) { item in
              li { "Item #\(item)" }
            }
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
        self.count -= 1
      }
    "Count: \(count)"
    button { "+" }
      .onClick {
        self.count += 1
      }
    
  }
}
