// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "swift-web",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax", from: "601.0.1"),
    .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.36.0")
  ],
  targets: [
    .macro(name: "SwiftHTMLMacros", dependencies: [
      .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
    ]),
    .executableTarget(
      name: "SwiftWebRoutesFinder",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
      ]
    ),
    .plugin(name: "SwiftWebRoutesFinderPlugin", capability: .buildTool(), dependencies: ["SwiftWebRoutesFinder"]),
    .target(name: "SwiftHTML"),
    .target(name: "SwiftWeb", dependencies: ["SwiftHTML", "JavaScriptKit", "SwiftHTMLMacros"], swiftSettings: [.defaultIsolation(MainActor.self)]),
    .executableTarget(
      name: "example",
      dependencies: ["SwiftWeb", "JavaScriptKit"],
      swiftSettings: [.defaultIsolation(MainActor.self)],
      linkerSettings: [
        // Aumenta la memoria WASM stack size
        .unsafeFlags(["-Xlinker", "-z", "-Xlinker", "stack-size=16777216"], .when(platforms: [.wasi]))
      ],
      plugins: [.plugin(name: "SwiftWebRoutesFinderPlugin")],
    ),
    .testTarget(
      name: "SwiftWebTests",
      dependencies: ["SwiftWeb", "SwiftHTML"],
      swiftSettings: [.defaultIsolation(MainActor.self)]
    ),
  ]
)
