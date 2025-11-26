import JavaScriptKit
import Foundation

let window = JSObject.global.window
let history = window.object!.history
let encoder = JSONEncoder()
let decoder = JSONDecoder()

public struct Router {
  public let jsHandler = JSHandler()
  
  public func onChange(_ listener: @escaping (String) -> Void) {
    jsHandler.onChange(listener)
  }
}

extension Router {
  public final class JSHandler {
    private(set) var currentPath: String = JSObject.global.location.pathname.string!
    private var listeners: [(String) -> Void] = []
    
    let originalPushState = history.pushState.function!
    let originalReplaceState = history.replaceState.function!
    
    fileprivate init() {
      let routeChangeEvent = "swiftRouteChange"
      
      history.pushState = .object(JSClosure { [weak self] args -> JSValue in
        guard let self else { return .undefined }
        let data = args[0]
        let unused = args[1]
        let url = args[2]
        
        _ = originalPushState.callAsFunction(this: history.object!, data, unused, url)
        _ = window.dispatchEvent(JSObject.global.Event.function!.new(routeChangeEvent))
        
        return .undefined
      })
      
      history.replaceState = .object(JSClosure { [weak self] args -> JSValue in
        guard let self else { return .undefined }

        let data = args[0]
        let unused = args[1]
        let url = args[2]
        
        _ = originalReplaceState.callAsFunction(this: history.object!, data, unused, url)
        _ = window.dispatchEvent(JSObject.global.Event.function!.new(routeChangeEvent))
        
        return .undefined
      })
      
      _ = window.addEventListener(routeChangeEvent, JSClosure { [weak self] _ in
        guard let self else { return .undefined }
        let newPath = JSObject.global.location.pathname.string!
        self.currentPath = newPath
        self.listeners.forEach { $0(newPath) }
        return .undefined
      })
      
      _ = window.addEventListener("popstate", JSClosure { [weak self] _ in
        guard let self else { return .undefined }
        let newPath = JSObject.global.location.pathname.string!
        self.currentPath = newPath
        self.listeners.forEach { $0(newPath) }
        return .undefined
      })
    }
    
    public func onChange(_ listener: @escaping (String) -> Void) {
      listeners.append(listener)
      listener(currentPath)
    }
    
    public func pushState(state: some Encodable, path: String) throws {
      _ = history.pushState(try encodableToJSValue(state), "", path)
    }
    
    public func pushState(path: String) {
      _ = history.pushState(JSValue.null, "", path)
    }
    
    public func replaceState(path: String) {
      _ = history.replaceState(JSValue.null, "", path)
    }
    
    public func replaceState(state: some Encodable, path: String) throws {
      _ = history.replaceState(try encodableToJSValue(state), "", path)
    }

    private func encodableToJSValue(_ codable: some Encodable) throws -> JSValue {
      let data = try encoder.encode(codable)
      guard let jsonString = String(data: data, encoding: .utf8) else {
        throw RouterError.jsonParseError
      }
      
      let json = JSObject.global.JSON
      return json.parse(jsonString)
    }
    
    public func extractParamFromRoute<T: Route.Param>(_ route: Route, index: Int,  type: T.Type = T.self) -> T {
      func extractValues(pattern: String, path: String) -> [String] {
        let patternParts = pattern.split(separator: "/")
        let pathParts = path.split(separator: "/")
        guard patternParts.count == pathParts.count else { return [] }
        
        var values: [String] = []
        for (p, v) in zip(patternParts, pathParts) {
          if p.hasPrefix("{") && p.hasSuffix("}") {
            values.append(String(v))
          }
        }
        return values
      }
      
      let location = window.location.object!
      let rawPath = location.pathname.string! // e.g: "/home/products/42"
      
      let trimmed = rawPath.hasPrefix("/") ? String(rawPath.dropFirst()) : rawPath
      
      let pattern = route.path   // e.g: "home/products/{pid}"
      let values = extractValues(pattern: pattern, path: trimmed)
      
      guard index < values.count else {
        fatalError("RouteParam: index out of range")
      }
      
      let valueString = values[index]
      
      do {
        return try T(string: valueString)
      } catch {
        fatalError("RouteParam: cannot convert \(valueString) to \(T.self): \(error)")
      }
    }
  }
}

extension Router {
  public struct Context {}
}

extension Router {
  public func push<P: WebPage>(_ destination: PageDestination<P>) {
    print(destination.resolvedPath)
    router.jsHandler.pushState(path: destination.resolvedPath)
  }
  
  public func replace<P: WebPage>(_ destination: PageDestination<P>) {
    print(destination.resolvedPath)
    router.jsHandler.replaceState(path: destination.resolvedPath)
  }
}

public protocol WebPage {
  static var route: Route { get }
}

public struct PageDestination<Page: WebPage> {
  public let resolvedPath: String
  public init<each Param: Route.Param>(page: Page.Type, params: repeat each Param) {
    var arguments: [String] = []
    for argument in repeat each params {
      arguments.append(argument.string)
    }
    resolvedPath = page.route.resolve(arguments: arguments)
  }
  
  public init(page: Page.Type) {
    resolvedPath = page.route.resolve(arguments: [])
  }
}

public struct RootPage: WebPage {
  public static let route: Route = "/"
}

extension PageDestination {
  public static func root() -> PageDestination<RootPage> {
    .init(page: RootPage.self)
  }
}

public enum RouterError: Error {
  case jsonParseError
}

public let router = Router()
