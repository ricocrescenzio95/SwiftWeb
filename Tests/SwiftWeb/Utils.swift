@testable import SwiftWeb

extension TreeRenderer {
  /// Debug helper: Print the current fiber tree
  func debugPrintTree() {
    guard let current = current else { return }
    if enableLogging {
      print("=== Current Fiber Tree ===")
      print(current)
    }
  }
  
  /// Debug helper: Print effect list
  func debugPrintEffects() {
    guard enableLogging else { return }
    
    print("=== Effect List ===")
    var effect = firstEffect
    var count = 0
    while let currentEffect = effect {
      print("\(count): \(currentEffect.effectTag) - \(currentEffect.tag)")
      effect = currentEffect.nextEffect
      count += 1
    }
    if count == 0 {
      print("(no effects)")
    }
  }
  
  /// Debug helper: Verify DOM matches fiber tree
  func debugVerifyDOM() {
    #if arch(wasm32)
    guard let root = current else { return }
    
    func verifyNode(_ fiber: Fiber) -> Bool {
      guard let domNode = fiber.domNode else {
        if enableLogging {
          print("⚠️ Fiber has no DOM node: \(fiber.tag)")
        }
        return false
      }
      
      // Verify children count
      let domChildCount = domNode.childNodes.length.number ?? 0
      if fiber.children.count != Int(domChildCount) {
        if enableLogging {
          print("⚠️ Child count mismatch for \(fiber.tag): fiber=\(fiber.children.count), dom=\(domChildCount)")
        }
        return false
      }
      
      // Recursively verify children
      for child in fiber.children {
        if !verifyNode(child) {
          return false
        }
      }
      
      return true
    }
    
    if enableLogging {
      if verifyNode(root) {
        print("✅ DOM verification passed")
      } else {
        print("❌ DOM verification failed")
      }
    } else {
      _ = verifyNode(root)
    }
    #endif
  }
}
