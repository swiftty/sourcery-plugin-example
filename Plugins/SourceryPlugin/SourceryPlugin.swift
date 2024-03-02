import Foundation
import PackagePlugin

private struct Config: Decodable {
    var templates: String?
}

@main
struct SourceryPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let projectPath = context.package.directory
        let cachePath = context.pluginWorkDirectory.appending(["Caches"])
        let buildPath = cachePath.appending(["build"])
        let output = context.pluginWorkDirectory.appending(["Generated"])

        let fileManager = FileManager.default

        let configPath = target.directory.appending("sourcery.json")
        let config: Config? = if fileManager.fileExists(atPath: configPath.string) {
            try JSONDecoder().decode(Config.self, from: Data(contentsOf: URL(fileURLWithPath: configPath.string)))
        } else {
            nil
        }

//        if !fileManager.fileExists(atPath: output.string) {
//            try? fileManager.createDirectory(at: URL(filePath: output.string), withIntermediateDirectories: true)
//        }

        return try [
            .prebuildCommand(
                displayName: "Sourcery BuildTool Plugin",
                executable: context.tool(named: "sourcery").path,
                arguments: [
                    "--cacheBasePath", cachePath,
                    "--buildPath", buildPath,
                    "--sources", fileManager.sourceDirectory(of: target.directory),
                    "--output", output,
                    "--verbose",
                ] + (config?.templates.map {
                    ["--templates", projectPath.appending([$0])]
                } ?? []),
                environment: [
                    "DERIVED_SOURCES_DIR": context.pluginWorkDirectory,
                ],
                outputFilesDirectory: output
            ),
        ]
    }
}

extension FileManager {
    func sourceDirectory(of target: Path) -> Path {
        let url = URL(filePath: target.string)
        return Path(url.resolvingSymlinksInPath().path())
    }
}
