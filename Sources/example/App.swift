import SwiftWeb
import Foundation
import JavaScriptKit

@main
@Component
struct TestApp: App {
  @State var items = (1...10).map(\.self)
  @State var isVisible = true
  
  var content: some Node {
    div {
      div {
        head {
          title { "Fiber Renderer Test" }
          style {
            """
            body { font-family: system-ui; padding: 20px; }
            .container { background: #f0f0f0; padding: 20px; border-radius: 8px; }
            button { padding: 10px 20px; margin: 10px 0; cursor: pointer; }
            .counter { font-size: 24px; font-weight: bold; color: #007AFF; }
            """
          }
        }
        div(.class("container")) {
          h1 { "Fiber Renderer Test" }
          p { "This tests the fiber rendering system." }
          
          p {}
          
          div(.id("test-output")) {
            h2 { "Test Output" }
            p { "Initial render complete!" }
          }
        }
      }
      CounterView()
      div {
        button {
          "Shuffle"
        }
        .onClick {
          items.shuffle()
        }
        button {
          "Add"
        }
        .onClick {
          items.insert(items.max()! + 1, at: 0)
        }
        button {
          "Remove"
        }
        .onClick {
          items.removeFirst()
        }
        button {
          isVisible ? "Hide" : "Show"
        }
        .onClick {
          isVisible.toggle()
        }
      }
      if isVisible {
        div {
          ol {
            ForEach(items, id: \.self) { item in
              li { item.description }
            }
          }
        }
      }
    }
  }
}

// MARK: - Counter Example with @State

@Component
struct CounterView {
  @State var count = 0
  
  var message = "Click the button!"

  var content: some Node {
    div {
      p { "Count: \(count)" }
      button {
        "Increment"
      }
      .onClick {
        count += 1
      }
    }
    //div {
    //  h2 { "Counter Example" }
    //  p(.class("counter")) { "Count: \(count)" }
    //  p { message }
    //
    //  button {
    //    "Increment"
    //  }
    //  .onClick {
    //    count += 1
    //  }
    //
    //  input()
    //    .onFocus {
    //      print($0)
    //    }
    //    .onBlur {
    //      print($0)
    //    }
    //
    //  button {
    //    "Reset"
    //  }
    //}
  }
}
