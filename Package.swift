// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sourcery-plugin-example",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "sourcery-plugin-example",
            targets: ["sourcery-plugin-example"]
        ),
    ],
    targets: [
        .target(
            name: "sourcery-plugin-example",
            exclude: [
                "sourcery.json"
            ],
            plugins: [
                "SourceryPlugin"
            ]
        ),
        .testTarget(
            name: "sourcery-plugin-exampleTests",
            dependencies: ["sourcery-plugin-example"]
        ),

        .binaryTarget(
            name: "SourceryBinary",
            url: "https://github.com/krzysztofzablocki/Sourcery/releases/download/2.1.7/sourcery-2.1.7.artifactbundle.zip",
            checksum: "b54ff217c78cada3f70d3c11301da03a199bec87426615b8144fc9abd13ac93b"
        ),

        .plugin(
            name: "SourceryPlugin",
            capability: .buildTool(),
            dependencies: [
                "SourceryBinary"
            ]
        )
    ]
)
