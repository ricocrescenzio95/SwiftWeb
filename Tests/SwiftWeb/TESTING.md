# Testing Guide for TreeRenderer

This document explains how to test the `TreeRenderer` and related components in this Swift web framework.

## Test Files

### 1. TestsRenderableTests.swift
Contains comprehensive unit tests for the TreeRenderer that can run without a browser environment.

**Test Suites:**
- **Fiber Tree Tests**: Tests for FiberConverter and basic fiber tree creation
- **TreeRenderer Initialization Tests**: Tests for initializing the renderer with an App
- **TreeRenderer Reconciliation Tests**: Tests for the reconciliation algorithm
- **Child Reconciliation Algorithm Tests**: Tests for complex child diffing scenarios
- **Effect Tag Tests**: Tests for effect tag functionality
- **Edge Cases and Error Handling**: Tests for edge cases, deep nesting, special characters
- **Debug Helper Tests**: Tests for debug utilities
- **Performance Characteristics**: Basic performance tests

### 2. TestsBrowserTests.swift
Contains tests that require a browser environment (WASM). These tests are disabled by default.

**Test Suites:**
- **Browser DOM Tests**: Tests for DOM node creation and manipulation
- **Full Integration Tests**: Tests for complete render cycles
- **Browser Stress Tests**: Performance tests with large lists and rapid updates

### 3. TestsQuickTests.swift
Contains manual test functions you can call from your app or browser console.

## Running Tests

### Running Unit Tests (macOS)

The unit tests in `TestsRenderableTests.swift` can run on macOS without WASM:

```bash
swift test
```

Or in Xcode:
1. Open your project
2. Press `Cmd+U` to run tests
3. Or use Product > Test from the menu

### Running Browser Tests (WASM)

The browser tests require compilation to WebAssembly:

1. **Compile to WASM:**
   ```bash
   swift build --triple wasm32-unknown-wasi
   ```

2. **Enable the tests** by removing the `.disabled` attribute from the test suites in `TestsBrowserTests.swift`

3. **Run in browser** with a test runner that supports Swift Testing in WASM

### Running Quick Tests Manually

You can call the quick test functions from your app or browser console:

1. **In your Swift code:**
   ```swift
   import SwiftWeb
   
   // Call directly
   runQuickTests()
   runBrowserTest()  // Browser only
   ```

2. **From browser console** (when running in WASM):
   ```javascript
   // Run quick tests
   swiftRunQuickTests();
   
   // Run browser tests
   swiftRunBrowserTest();
   ```

## Test Coverage

### What's Tested

✅ **Fiber Tree Creation**
- Converting HTML elements to fiber trees
- Text node handling
- Attribute preservation
- Nested structures
- Parent references

✅ **Reconciliation**
- New fiber placement
- Attribute changes detection
- Text content changes
- Tag type changes
- Child additions, removals, and reordering

✅ **Child Reconciliation**
- Matching children in order (fast path)
- Inserting at beginning, middle, end
- Deleting from different positions
- Complex reordering scenarios

✅ **Edge Cases**
- Empty trees
- Deep nesting
- Many siblings
- Mixed content types
- Special characters
- Empty text nodes

✅ **Performance**
- Large tree conversion
- Incremental updates
- Stress tests with 1000+ items

✅ **DOM Operations** (Browser only)
- Creating text nodes
- Creating elements with attributes
- Nested DOM structures
- Updating attributes
- Removing attributes

## Writing New Tests

### Using Swift Testing

This project uses the modern Swift Testing framework with the `@Test` macro:

```swift
import Testing
import SwiftHTML
@testable import SwiftWeb

@Suite("My Test Suite")
struct MyTests {
  
  @Test("Description of what this tests")
  func myTest() async throws {
    let renderer = TreeRenderer()
    renderer.enableLogging = false  // Silence output in tests
    
    // Your test code here
    
    // Use #expect for assertions
    #expect(renderer.current == nil)
  }
}
```

### Test Best Practices

1. **Disable logging in tests:**
   ```swift
   renderer.enableLogging = false
   ```

2. **Use descriptive test names:**
   ```swift
   @Test("Adding children updates tree correctly")
   func addingChildren() async throws { }
   ```

3. **Test one thing per test:**
   Each test should verify a single behavior

4. **Use the helper methods:**
   ```swift
   renderer.debugPrintTree()      // Print current fiber tree
   renderer.debugPrintEffects()   // Print effect list
   renderer.debugVerifyDOM()      // Verify DOM matches (WASM only)
   ```

5. **For browser tests, use platform checks:**
   ```swift
   #if arch(wasm32)
   // Browser-specific code
   #else
   throw XCTSkip("This test requires WASM environment")
   #endif
   ```

## Debugging Tests

### Print Fiber Tree Structure

```swift
let renderer = TreeRenderer()
let app = MyApp()
renderer.start(app: app)
renderer.debugPrintTree()
```

Output:
```
=== Current Fiber Tree ===
html
 |_ body
   |_ div [class="container"]
     |_ h1
       |_ (text: "Hello")
```

### Print Effect List

```swift
renderer.performWork(newTree: newHTML)
renderer.debugPrintEffects()
```

Output:
```
=== Effect List ===
0: placement - p
1: update - div
2: deletion - span
```

### Verify DOM Matches Fiber Tree

```swift
renderer.debugVerifyDOM()  // WASM only
```

## Common Issues

### Issue: "Cannot find type in scope"
**Solution:** Make sure you import the module with `@testable`:
```swift
@testable import SwiftWeb
```

### Issue: Browser tests won't run
**Solution:** These tests require WASM compilation and a browser environment. They're disabled by default. Only enable when running in browser.

### Issue: Tests are too slow
**Solution:** Disable logging in tests:
```swift
renderer.enableLogging = false
```

### Issue: "XCTSkip" not available
**Solution:** Use the throwing approach for Swift Testing:
```swift
#if !arch(wasm32)
throw XCTSkip("Requires WASM")
#endif
```

## Performance Testing

The test suite includes basic performance checks:

```swift
let startTime = Date()
// ... operation ...
let duration = Date().timeIntervalSince(startTime)
#expect(duration < 1.0, "Operation too slow: \(duration)s")
```

For more comprehensive performance testing, use Xcode's Instruments:
1. Product > Profile (Cmd+I)
2. Choose "Time Profiler"
3. Run your tests

## Continuous Integration

To run tests in CI:

```yaml
# .github/workflows/test.yml
- name: Run Tests
  run: swift test
```

For WASM tests, you'll need a browser automation setup like Playwright or Selenium.

## Additional Resources

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [SwiftWasm Documentation](https://book.swiftwasm.org/)
- [JavaScriptKit Documentation](https://github.com/swiftwasm/JavaScriptKit)

## Questions?

If you encounter issues or need help:
1. Check the test output for detailed error messages
2. Use the debug helpers to inspect state
3. Look at existing tests for examples
4. Review the TreeRenderer implementation in `Renderable.swift`
