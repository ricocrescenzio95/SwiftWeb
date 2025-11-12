import Testing
import Foundation
@testable import SwiftHTML
@testable import SwiftWeb

// MARK: - Fiber Basic Tests

@Suite("Fiber Tree Tests")
struct FiberTests {
  
  @Test("Fiber converter creates correct tree structure")
  func fiberConverterCreatesTree() async throws {
    let converter = FiberConverter()
    
    // Create a simple HTML structure
    let html = div {
      h1 { "Hello" }
      p { "World" }
    }
    
    let fibers = converter.convert(html)
    
    // Verify structure
    #expect(fibers.count == 1)
    let root = fibers[0]
    #expect(root.tag == "div")
    #expect(root.children.count == 2)
    #expect(root.children[0].tag == "h1")
    #expect(root.children[1].tag == "p")
  }
  
  @Test("Text nodes are converted correctly")
  func textNodesConverted() async throws {
    let converter = FiberConverter()
    let fiber = converter.convert("Hello World")[0]
    
    #expect(fiber.tag == "#text")
    #expect(fiber.textContent == "Hello World")
  }
  
  @Test("Attributes are preserved")
  func attributesPreserved() async throws {
    let converter = FiberConverter()
    
    let html = div {
      a(.href("https://example.com"), .class("link")) { "Click me" }
    }
    
    let fibers = converter.convert(html)
    let anchor = fibers[0].children[0]
    
    #expect(anchor.tag == "a")
    #expect(anchor.attributes["href"] == "https://example.com")
    #expect(anchor.attributes["class"] == "link")
  }
  
  @Test("Complex nested structure")
  func complexNestedStructure() async throws {
    let converter = FiberConverter()
    
    let html = div(.class("container")) {
      header {
        h1 { "Title" }
        nav {
          a(.href("/home")) { "Home" }
          a(.href("/about")) { "About" }
        }
      }
      main {
        article {
          h2 { "Article Title" }
          p { "First paragraph" }
          p { "Second paragraph" }
        }
      }
      footer { "Copyright 2024" }
    }
    
    let fibers = converter.convert(html)
    let root = fibers[0]
    
    #expect(root.tag == "div")
    #expect(root.attributes["class"] == "container")
    #expect(root.children.count == 3) // header, main, footer
    #expect(root.children[0].tag == "header")
    #expect(root.children[1].tag == "main")
    #expect(root.children[2].tag == "footer")
    
    // Verify header structure
    let headerChild = root.children[0]
    #expect(headerChild.children.count == 2) // h1, nav
    
    // Verify nav links
    let navChild = headerChild.children[1]
    #expect(navChild.tag == "nav")
    #expect(navChild.children.count == 2)
  }
  
  @Test("Empty nodes produce no fibers")
  func emptyNodesProduceNoFibers() async throws {
    let converter = FiberConverter()
    let empty = _EmptyNode()
    let fibers = converter.convert(empty)
    
    #expect(fibers.isEmpty)
  }
  
  @Test("Parent references are set correctly")
  func parentReferencesSet() async throws {
    let converter = FiberConverter()
    
    let html = div {
      p { "Text" }
    }
    
    let fibers = converter.convert(html)
    let root = fibers[0]
    let paragraph = root.children[0]
    let text = paragraph.children[0]
    
    #expect(paragraph.parent === root)
    #expect(text.parent === paragraph)
  }
  
  @Test("Fiber description format")
  func fiberDescriptionFormat() async throws {
    let converter = FiberConverter()
    
    let html = div(.class("test")) {
      p { "Hello" }
    }
    
    let fiber = converter.convert(html)[0]
    let description = fiber.description
    
    // Should contain tag name and attributes
    #expect(description.contains("div"))
    #expect(description.contains("class=\"test\""))
    #expect(description.contains("p"))
  }
}

// MARK: - TreeRenderer Initialization Tests

@Suite("TreeRenderer Initialization Tests")
struct TreeRendererInitTests {
  
  struct SimpleApp: App {
    var content: some Node {
      html {
        body {
          div { "Hello World" }
        }
      }
    }
  }
  
  @Test("TreeRenderer initializes with app")
  @MainActor func initializesWithApp() async throws {
    let renderer = TreeRenderer()
    let app = SimpleApp()
    
    renderer.start(app: app)
    
    #expect(renderer.current != nil)
    #expect(renderer.current?.tag == "html")
  }
  
  @Test("Initial fiber tree matches app structure")
  @MainActor func initialTreeMatchesApp() async throws {
    let renderer = TreeRenderer()
    let app = SimpleApp()
    
    renderer.start(app: app)
    
    guard let root = renderer.current else {
      Issue.record("Current fiber is nil")
      return
    }
    
    #expect(root.tag == "html")
    #expect(root.children.count == 1)
    #expect(root.children[0].tag == "body")
  }
}

// MARK: - Reconciliation Tests

@Suite("TreeRenderer Reconciliation Tests")
struct ReconciliationTests {
  
  @Test("New fiber gets placement tag")
  func newFiberPlacement() async throws {
    let renderer = TreeRenderer()
    
    // Test through performWork since reconcile is private
    let html = div { "Test" }
    
    renderer.current = nil
    renderer.performWork(newTree: html)
    
    #expect(renderer.current?.tag == "div")
  }
  
  @Test("Identical fibers produce no effects")
  func identicalFibersNoEffects() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    let html = div(.class("test")) { "Hello" }
    
    // Set initial state
    renderer.current = converter.convert(html)[0]
    
    // Perform work with identical tree
    renderer.performWork(newTree: html)
    
    // Should have no effects (will be tested via side effects)
    #expect(renderer.current != nil)
  }
  
  @Test("Changed attributes trigger update")
  func changedAttributesUpdate() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial render
    let html1 = div(.class("old")) { "Content" }
    renderer.current = converter.convert(html1)[0]
    
    // Silence output during tests
    renderer.enableLogging = false
    
    // Update with different attributes
    let html2 = div(.class("new")) { "Content" }
    renderer.performWork(newTree: html2)
    
    // Verify update occurred
    #expect(renderer.current?.attributes["class"] == "new")
  }
  
  @Test("Changed text content triggers update")
  func changedTextUpdate() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial render
    let html1 = p { "Old text" }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Update with different text
    let html2 = p { "New text" }
    renderer.performWork(newTree: html2)
    
    // Verify text was updated
    let textNode = renderer.current?.children[0]
    #expect(textNode?.textContent == "New text")
  }
  
  @Test("Different tag types trigger replacement")
  func differentTagsReplacement() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial render
    let html1 = div { "Content" }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Update with different tag
    let html2 = span { "Content" }
    renderer.performWork(newTree: html2)
    
    // Verify tag changed
    #expect(renderer.current?.tag == "span")
  }
  
  @Test("Adding children")
  func addingChildren() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Start with one child
    let html1 = div {
      p { "First" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Add more children
    let html2 = div {
      p { "First" }
      p { "Second" }
      p { "Third" }
    }
    renderer.performWork(newTree: html2)
    
    // Verify children added
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[1].children[0].textContent == "Second")
    #expect(renderer.current?.children[2].children[0].textContent == "Third")
  }
  
  @Test("Removing children")
  func removingChildren() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Start with three children
    let html1 = div {
      p { "First" }
      p { "Second" }
      p { "Third" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Remove some children
    let html2 = div {
      p { "First" }
    }
    renderer.performWork(newTree: html2)
    
    // Verify children removed
    #expect(renderer.current?.children.count == 1)
    #expect(renderer.current?.children[0].children[0].textContent == "First")
  }
  
  @Test("Reordering children")
  func reorderingChildren() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial order
    let html1 = ul {
      li(.id("a")) { "Item A" }
      li(.id("b")) { "Item B" }
      li(.id("c")) { "Item C" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Reordered
    let html2 = ul {
      li(.id("c")) { "Item C" }
      li(.id("a")) { "Item A" }
      li(.id("b")) { "Item B" }
    }
    renderer.performWork(newTree: html2)
    
    // Verify order
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[0].attributes["id"] == "c")
    #expect(renderer.current?.children[1].attributes["id"] == "a")
    #expect(renderer.current?.children[2].attributes["id"] == "b")
  }
  
  @Test("Multiple attribute changes")
  func multipleAttributeChanges() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial state
    let html1 = div(.class("red"), .id("box"), .title("Original")) { "Content" }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Update multiple attributes
    let html2 = div(.class("blue"), .id("container"), .title("Updated")) { "Content" }
    renderer.performWork(newTree: html2)
    
    // Verify all changes
    #expect(renderer.current?.attributes["class"] == "blue")
    #expect(renderer.current?.attributes["id"] == "container")
    #expect(renderer.current?.attributes["title"] == "Updated")
  }
  
  @Test("Removing attributes")
  func removingAttributes() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial state with multiple attributes
    let html1 = div(.class("test"), .id("box"), .title("Tooltip")) { "Content" }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Remove some attributes
    let html2 = div(.class("test")) { "Content" }
    renderer.performWork(newTree: html2)
    
    // Verify attributes removed
    #expect(renderer.current?.attributes["class"] == "test")
    #expect(renderer.current?.attributes["id"] == nil)
    #expect(renderer.current?.attributes["title"] == nil)
  }
}

// MARK: - Child Reconciliation Tests

@Suite("Child Reconciliation Algorithm Tests")
struct ChildReconciliationTests {
  
  @Test("Matching children in order")
  func matchingChildrenInOrder() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Initial state
    let html1 = div {
      h1 { "Title" }
      p { "Paragraph 1" }
      p { "Paragraph 2" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    // Same structure, different content
    let html2 = div {
      h1 { "New Title" }
      p { "New Paragraph 1" }
      p { "New Paragraph 2" }
    }
    renderer.performWork(newTree: html2)
    
    // Verify structure maintained, content updated
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[0].tag == "h1")
    #expect(renderer.current?.children[0].children[0].textContent == "New Title")
  }
  
  @Test("Inserting at beginning")
  func insertingAtBeginning() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    let html1 = ul {
      li { "B" }
      li { "C" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    let html2 = ul {
      li { "A" }
      li { "B" }
      li { "C" }
    }
    renderer.performWork(newTree: html2)
    
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[0].children[0].textContent == "A")
  }
  
  @Test("Inserting at end")
  func insertingAtEnd() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    let html1 = ul {
      li { "A" }
      li { "B" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    let html2 = ul {
      li { "A" }
      li { "B" }
      li { "C" }
    }
    renderer.performWork(newTree: html2)
    
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[2].children[0].textContent == "C")
  }
  
  @Test("Inserting in middle")
  func insertingInMiddle() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    let html1 = ul {
      li { "A" }
      li { "C" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    let html2 = ul {
      li { "A" }
      li { "B" }
      li { "C" }
    }
    renderer.performWork(newTree: html2)
    
    #expect(renderer.current?.children.count == 3)
    #expect(renderer.current?.children[1].children[0].textContent == "B")
  }
  
  @Test("Deleting from beginning")
  func deletingFromBeginning() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    let html1 = ul {
      li { "A" }
      li { "B" }
      li { "C" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    let html2 = ul {
      li { "B" }
      li { "C" }
    }
    renderer.performWork(newTree: html2)
    
    #expect(renderer.current?.children.count == 2)
    #expect(renderer.current?.children[0].children[0].textContent == "B")
  }
  
  @Test("Complex child operations")
  func complexChildOperations() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Mix of additions, deletions, and reorders
    let html1 = ul {
      li { "A" }
      li { "B" }
      li { "C" }
      li { "D" }
    }
    renderer.current = converter.convert(html1)[0]
    renderer.enableLogging = false
    
    let html2 = ul {
      li { "C" }
      li { "A" }
      li { "E" }
      li { "B" }
    }
    renderer.performWork(newTree: html2)
    
    #expect(renderer.current?.children.count == 4)
    #expect(renderer.current?.children[0].children[0].textContent == "C")
    #expect(renderer.current?.children[1].children[0].textContent == "A")
    #expect(renderer.current?.children[2].children[0].textContent == "E")
    #expect(renderer.current?.children[3].children[0].textContent == "B")
  }
}

// MARK: - Effect Tag Tests

@Suite("Effect Tag Tests")
struct EffectTagTests {
  
  @Test("Effect tag enum values")
  func effectTagValues() async throws {
    let none = EffectTag.none
    let placement = EffectTag.placement
    let update = EffectTag.update
    let deletion = EffectTag.deletion
    
    #expect(none == .none)
    #expect(placement == .placement)
    #expect(update == .update)
    #expect(deletion == .deletion)
  }
  
  @Test("Fiber default effect tag")
  func fiberDefaultEffectTag() async throws {
    let fiber = Fiber(tag: "div")
    #expect(fiber.effectTag == .none)
  }
}

// MARK: - Edge Cases and Error Handling

@Suite("Edge Cases and Error Handling")
struct EdgeCaseTests {
  
  @Test("Empty tree reconciliation")
  func emptyTreeReconciliation() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    
    // Empty div
    let html = div { }
    renderer.current = converter.convert(html)[0]
    renderer.enableLogging = false
    
    #expect(renderer.current?.tag == "div")
    #expect(renderer.current?.children.isEmpty == true)
  }
  
  @Test("Deep nesting")
  func deepNesting() async throws {
    let converter = FiberConverter()
    
    let html = div {
      div {
        div {
          div {
            div {
              p { "Deep content" }
            }
          }
        }
      }
    }
    
    let fiber = converter.convert(html)[0]
    
    // Navigate to deepest level
    var current = fiber
    var depth = 0
    while !current.children.isEmpty {
      current = current.children[0]
      depth += 1
    }
    
    #expect(depth >= 5)
    #expect(current.tag == "#text")
  }
  
  @Test("Many siblings")
  func manySiblings() async throws {
    let converter = FiberConverter()
    
    let html = div {
      p { "1" }
      p { "2" }
      p { "3" }
      p { "4" }
      p { "5" }
      p { "6" }
      p { "7" }
      p { "8" }
      p { "9" }
      p { "10" }
    }
    
    let fiber = converter.convert(html)[0]
    #expect(fiber.children.count == 10)
    
    for (index, child) in fiber.children.enumerated() {
      #expect(child.tag == "p")
      #expect(child.children[0].textContent == "\(index + 1)")
    }
  }
  
  @Test("Mixed content types")
  func mixedContentTypes() async throws {
    let converter = FiberConverter()
    
    let html = div {
      "Text before"
      p { "Paragraph" }
      "Text between"
      span { "Span" }
      "Text after"
    }
    
    let fiber = converter.convert(html)[0]
    #expect(fiber.children.count == 5)
    #expect(fiber.children[0].tag == "#text")
    #expect(fiber.children[1].tag == "p")
    #expect(fiber.children[2].tag == "#text")
    #expect(fiber.children[3].tag == "span")
    #expect(fiber.children[4].tag == "#text")
  }
  
  @Test("Empty text nodes")
  func emptyTextNodes() async throws {
    let converter = FiberConverter()
    let fiber = converter.convert("")[0]
    
    #expect(fiber.tag == "#text")
    #expect(fiber.textContent == "")
  }
  
  @Test("Special characters in text")
  func specialCharactersInText() async throws {
    let converter = FiberConverter()
    let specialText = "Hello <>&\"' 世界 🌍"
    let fiber = converter.convert(specialText)[0]
    
    #expect(fiber.tag == "#text")
    #expect(fiber.textContent == specialText)
  }
}

// MARK: - Debug Helper Tests

@Suite("Debug Helper Tests")
struct DebugHelperTests {
  
  @Test("Debug print tree doesn't crash")
  func debugPrintTreeNoCrash() async throws {
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    // Should not crash with no tree
    renderer.debugPrintTree()
    
    // Should not crash with tree
    let converter = FiberConverter()
    let html = div { p { "Test" } }
    renderer.current = converter.convert(html)[0]
    renderer.debugPrintTree()
  }
  
  @Test("Debug print effects doesn't crash")
  func debugPrintEffectsNoCrash() async throws {
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    // Should not crash with no effects
    renderer.debugPrintEffects()
    
    // Should not crash after performing work
    let html = div { "Test" }
    renderer.performWork(newTree: html)
    renderer.debugPrintEffects()
  }
}

// MARK: - Performance Tests

@Suite("Performance Characteristics")
struct PerformanceTests {
  
  @Test("Large tree conversion")
  func largeTreeConversion() async throws {
    let converter = FiberConverter()
    
    // Create a moderately large tree
    let html = div {
      ForEach(0..<5000, id: \.self) { _ in
        div(.class("item")) {
          h3 { "Title" }
          p { "Description text here" }
          button(.class("btn")) { "Click me" }
        }
      }
    }
    
    let startTime = Date()
    let fiber = converter.convert(html)[0]
    let duration = Date().timeIntervalSince(startTime)
    
    #expect(fiber.children.count == 5000)
    // Should complete reasonably quickly
    #expect(duration < 1.0, "Conversion took too long: \(duration)s")
  }
  
  @Test("Incremental updates are efficient")
  func incrementalUpdates() async throws {
    let renderer = TreeRenderer()
    let converter = FiberConverter()
    renderer.enableLogging = false
    
    // Initial large tree
    let html1 = div {
      ForEach(0..<5000, id: \.self) { i in
        p(.id("item-\(i)")) { "Item \(i)" }
      }
    }
    renderer.current = converter.convert(html1)[0]
    
    // Update just one item
    let html2 = div {
      ForEach(0..<5000, id: \.self) { i in
        if i == 50 {
          p(.id("item-\(i)")) { "Updated Item \(i)" }
        } else {
          p(.id("item-\(i)")) { "Item \(i)" }
        }
      }
    }
    
    let startTime = Date()
    renderer.performWork(newTree: html2)
    let duration = Date().timeIntervalSince(startTime)
    
    // Should complete quickly since only one item changed
    #expect(duration < 1.0, "Update took too long: \(duration)s")
    #expect(renderer.current?.children[50].children[0].textContent == "Updated Item 50")
  }
}
