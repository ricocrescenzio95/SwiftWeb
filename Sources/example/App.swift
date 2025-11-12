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
          """
          body {
            font-family: system-ui;
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
          }
          h1 {
            color: #007AFF;
          }
          .box {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
          }
          button {
            padding: 10px 20px;
            margin: 5px;
            background: #007AFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
          }
          """
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
          button { "Shuffle" }
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
  @State var count: Int
  
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
