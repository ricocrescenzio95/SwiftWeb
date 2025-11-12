import JavaScriptKit
import SwiftHTML
import Testing
import XCTest
@testable import SwiftWeb

// These tests need to run in a browser environment (via SwiftWasm)
// To run: compile to WASM and run in a browser with test runner
@Suite("Browser DOM Tests", .disabled()) // Disable by default, enable when running in browser
struct BrowserDOMTests {
  
  @Test("Create text node in DOM")
  func createTextNode() async throws {
    #if arch(wasm32)
    let fiber = Fiber(tag: "#text", textContent: "Hello")
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    
    #expect(node.nodeValue.string == "Hello")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Create element with attributes")
  func createElement() async throws {
    #if arch(wasm32)
    let fiber = Fiber(tag: "div", attributes: ["class": "test", "id": "main"])
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    
    let className = node.getAttribute?("class").string
    let id = node.getAttribute?("id").string
    
    #expect(className == "test")
    #expect(id == "main")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Create nested elements")
  func createNestedElements() async throws {
    #if arch(wasm32)
    let converter = FiberConverter()
    
    let html = div(.class("container")) {
      h1 { "Title" }
      p { "Content" }
    }
    
    let fiber = converter.convert(html)[0]
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    
    #expect(node.childNodes?.length.number == 2)
    #expect(node.firstChild?.nodeName.string?.lowercased() == "h1")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Element with multiple attributes")
  func elementWithMultipleAttributes() async throws {
    #if arch(wasm32)
    let fiber = Fiber(tag: "input", attributes: [
      "type": "text",
      "placeholder": "Enter name",
      "class": "form-input",
      "required": "required"
    ])
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    
    #expect(node.getAttribute?("type").string == "text")
    #expect(node.getAttribute?("placeholder").string == "Enter name")
    #expect(node.getAttribute?("class").string == "form-input")
    #expect(node.getAttribute?("required").string == "required")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Deep nested structure")
  func deepNestedStructure() async throws {
    #if arch(wasm32)
    let converter = FiberConverter()
    
    let html = div(.class("outer")) {
      div(.class("middle")) {
        div(.class("inner")) {
          p { "Deep content" }
        }
      }
    }
    
    let fiber = converter.convert(html)[0]
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    
    // Navigate to deepest element
    let middle = node.firstChild
    let inner = middle?.firstChild
    let paragraph = inner?.firstChild
    
    #expect(paragraph?.nodeName.string?.lowercased() == "p")
    #expect(paragraph?.textContent.string == "Deep content")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Update attributes in DOM")
  func updateAttributesInDOM() async throws {
    #if arch(wasm32)
    let fiber = Fiber(tag: "div", attributes: ["class": "old"])
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    fiber.domNode = node
    
    // Verify initial attribute
    #expect(node.getAttribute?("class").string == "old")
    
    // Update attributes
    renderer.updateAttributes(
      node: node,
      oldAttrs: ["class": "old"],
      newAttrs: ["class": "new", "id": "test"]
    )
    
    // Verify updates
    #expect(node.getAttribute?("class").string == "new")
    #expect(node.getAttribute?("id").string == "test")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Remove attributes from DOM")
  func removeAttributesFromDOM() async throws {
    #if arch(wasm32)
    let fiber = Fiber(tag: "div", attributes: [
      "class": "test",
      "id": "box",
      "title": "tooltip"
    ])
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    let node = renderer.createDOMNode(fiber)
    fiber.domNode = node
    
    // Remove some attributes
    renderer.updateAttributes(
      node: node,
      oldAttrs: ["class": "test", "id": "box", "title": "tooltip"],
      newAttrs: ["class": "test"]
    )
    
    // Verify class remains
    #expect(node.getAttribute?("class").string == "test")
    
    // Verify others removed (getAttribute returns null/undefined)
    let idValue = node.getAttribute?("id")
    let titleValue = node.getAttribute?("title")
    #expect(idValue == nil || idValue?.isNull == true || idValue?.isUndefined == true)
    #expect(titleValue == nil || titleValue?.isNull == true || titleValue?.isUndefined == true)
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
}

// MARK: - Full Integration Tests

@Suite("Full Integration Tests (Browser)", .disabled())
struct BrowserIntegrationTests {
  struct TestApp: App {
    var content: some Node {
      html {
        body {
          div(.id("root")) {
            h1 { "Test App" }
            p { "Hello World" }
          }
        }
      }
    }
  }
  
  @Test("Full render cycle")
  func fullRenderCycle() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    
    // Clear document body
    let document = JSObject.global.document
    let body = document.body
    body.innerHTML = .string("")
    
    // Initial render
    let converter = FiberConverter()
    let html1 = div(.id("app")) {
      h1 { "Hello" }
    }
    
    let fiber = converter.convert(html1)[0]
    fiber.domNode = renderer.createDOMNode(fiber)
    renderer.current = fiber
    
    // Append to body
    _ = body.appendChild?(fiber.domNode!)
    
    // Verify initial render
    let app = document.getElementById("app")
    #expect(app != nil)
    #expect(app?.childNodes?.length.number == 1)
    
    // Update
    let html2 = div(.id("app")) {
      h1 { "Hello" }
      p { "World" }
    }
    
    renderer.performWork(newTree: html2)
    
    // Verify update
    let updatedApp = document.getElementById("app")
    #expect(updatedApp?.childNodes?.length.number == 2)
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Start with app structure")
  func startWithAppStructure() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    let app = TestApp()
    
    // Clear body
    let document = JSObject.global.document
    let body = document.body
    body.innerHTML = .string("")
    
    renderer.start(app: app)
    
    // Verify tree created
    #expect(renderer.current != nil)
    #expect(renderer.current?.tag == "html")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Multiple sequential updates")
  func multipleSequentialUpdates() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    let converter = FiberConverter()
    
    // Clear body
    let document = JSObject.global.document
    let body = document.body
    body.innerHTML = .string("")
    
    // Initial state
    let html1 = div(.id("counter")) { "Count: 0" }
    let fiber1 = converter.convert(html1)[0]
    fiber1.domNode = renderer.createDOMNode(fiber1)
    renderer.current = fiber1
    _ = body.appendChild?(fiber1.domNode!)
    
    // Update 1
    let html2 = div(.id("counter")) { "Count: 1" }
    renderer.performWork(newTree: html2)
    
    let counter1 = document.getElementById("counter")
    #expect(counter1?.textContent.string == "Count: 1")
    
    // Update 2
    let html3 = div(.id("counter")) { "Count: 2" }
    renderer.performWork(newTree: html3)
    
    let counter2 = document.getElementById("counter")
    #expect(counter2?.textContent.string == "Count: 2")
    
    // Update 3
    let html4 = div(.id("counter")) { "Count: 3" }
    renderer.performWork(newTree: html4)
    
    let counter3 = document.getElementById("counter")
    #expect(counter3?.textContent.string == "Count: 3")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("DOM verification helper")
  func domVerificationHelper() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    let converter = FiberConverter()
    
    let html = div {
      h1 { "Title" }
      p { "Content" }
    }
    
    let fiber = converter.convert(html)[0]
    fiber.domNode = renderer.createDOMNode(fiber)
    renderer.current = fiber
    
    // This should verify successfully
    renderer.debugVerifyDOM()
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
}

// MARK: - Stress Tests

@Suite("Browser Stress Tests", .disabled())
struct BrowserStressTests {
  
  @Test("Large list rendering")
  func largeListRendering() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    let converter = FiberConverter()
    
    // Create a large list
    let html = ul(.id("large-list")) {
      for i in 0..<1000 {
        li { "Item \(i)" }
      }
    }
    
    let startTime = Date()
    let fiber = converter.convert(html)[0]
    fiber.domNode = renderer.createDOMNode(fiber)
    let duration = Date().timeIntervalSince(startTime)
    
    // Should complete in reasonable time
    #expect(duration < 5.0, "Rendering 1000 items took \(duration)s")
    
    // Verify structure
    #expect(fiber.domNode?.childNodes?.length.number == 1000)
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
  
  @Test("Rapid updates")
  func rapidUpdates() async throws {
    #if arch(wasm32)
    let renderer = TreeRenderer()
    renderer.enableLogging = false
    let converter = FiberConverter()
    
    // Initial state
    let html1 = div(.id("rapid")) { "0" }
    renderer.current = converter.convert(html1)[0]
    
    let startTime = Date()
    
    // Perform 100 rapid updates
    for i in 1...100 {
      let html = div(.id("rapid")) { "\(i)" }
      renderer.performWork(newTree: html)
    }
    
    let duration = Date().timeIntervalSince(startTime)
    
    // Should complete quickly
    #expect(duration < 2.0, "100 updates took \(duration)s")
    
    // Verify final state
    #expect(renderer.current?.children[0].textContent == "100")
    #else
    throw XCTSkip("This test requires WASM environment")
    #endif
  }
}
