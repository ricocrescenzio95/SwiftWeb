import SwiftWeb
import JavaScriptKit
import Foundation

@main
@Component
struct TestApp: App {
  @State var isVisible: Bool = false
  @State var items: [Int] = (1...50).map(\.self)
  @State var text: String = "hello"
  @State var checked: Bool = false
  @State var date: Date? = .now
  @State var selectedColor: String = "#000000"
  @State var file: String = ""

  var content: some Node {
    head {
      title { "V2 Renderer Test" }
      style {
        "a".css {
          fontFamily("system-ui")
          padding(40)
        }
        "body".css {
          fontFamily("system-ui")
          padding(40)
          maxWidth(800)
          margin(.init(vertical: 0, horizontal: .auto))
        }
        "h1".css {
          color(.hex("#007AFF"))
        }
        ".box".css {
          backgroundColor(.hex("#F5F5F5"))
          padding(20)
          borderRadius(8)
          margin(.init(vertical: 20, horizontal: .zero))
        }
        "button".css {
          padding(.init(vertical: 10, horizontal: 20))
          margin(5)
          backgroundColor(.hex("#007AFF"))
          color(.white)
          border("none")
          borderRadius(4)
          cursor(.pointer)
        }
      }
    }
    body(.class("flex flex-col gap-4")) {
      h1(.class("text-4xl")) { "🧪 V2 Renderer Test" }
      div(.class("flex flex-col gap-2")) {
        p(.class("font-medium text-lg")) { "Input types"}
        input(.value(text), .class("border p-2 rounded"))
        input(text: $text, .class("border p-2 rounded"))
        input(date: $date)
        div(.class("flex gap-2 p-2 border rounded")) {
          input(color: $selectedColor)
          input(text: $selectedColor)
        }
        input(dateTime: $date)
        input(.type(.checkbox), .checked(checked))
          .onChange {
            print("changed", $0.target.checked)
            checked = true
          }
        div(.class("flex gap-2 p-2 border rounded")) {
          input(file: $file)
          file
        }
      }
      div(.class("box")) {
        h2 { "Static Content" }
        p { "If you see this, basic rendering works! ✅" }
      }
      
      div(.class("box")) {
        h2 { "Event Handler Test" }
        CounterView()
        button { p { "Test Click" } }
          .onClick {
            print("🎉 Event handler works!")
          }
          .onClick {
            router.push(.productDetail(id: "1", id2: "4"))
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
          .style {
            if isVisible {
              backgroundColor(.aqua)
              color(.black)
            }
          }
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
          forEach(items, key: \.self) { item in
            li { "Item #\(item)" }
          }
        }
      }
    }
  }
  
  static var notFound: some Node {
    body(.class("flex flex-col gap-4 size-full items-center justify-center")) {
      p(.class("font-medium text-lg")) {
        "404 - Not Found"
      }
      button {
        "Go back home"
      }
      .onClick {
        router.replace(.root())
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

@Page(route: "products/\(param: "id")/\(param: "id2")")
struct ProductDetail: Node {
  @State var test: Int = 0
  
  var content: some Node {
    div(.class("flex flex-col gap-4")) {
      "Product with id \(id) \(id2)"
      button(.class("border rounded cursor-pointer px-2")) {
        "Go home"
      }
      .onClick {
        router.replace(.root())
      }
    }
  }
}
