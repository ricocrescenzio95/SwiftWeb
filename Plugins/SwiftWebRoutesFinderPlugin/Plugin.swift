import Foundation
import PackagePlugin

@main
struct Plugin: BuildToolPlugin {
  func createBuildCommands(
    context: PluginContext,
    target: any Target
  ) throws -> [Command] {
    var swiftFiles: [URL] = []
    
    let inputDirectory = target.directoryURL
    if let enumerator = FileManager.default.enumerator(
      at: inputDirectory,
      includingPropertiesForKeys: [.isRegularFileKey],
      options: [.skipsHiddenFiles]
    ) {
      for case let fileURL as URL in enumerator {
        guard fileURL.pathExtension == "swift" else { continue }
        swiftFiles.append(fileURL)
      }
    }

    let outputDirectory = context.pluginWorkDirectoryURL
      .appending(path: "routes")
    let outputFile = outputDirectory
      .appending(path: "generated.swift")
    
    FileManager.default.createFile(atPath: outputFile.absoluteString, contents: nil)
    
    return try [
      .buildCommand(
        displayName: "SwiftWeb Routes Finder",
        executable: context.tool(named: "SwiftWebRoutesFinder").url,
        arguments: [inputDirectory.absoluteString, outputFile.absoluteString],
        inputFiles: swiftFiles,
        outputFiles: [outputFile]
      )
    ]
  }
}
