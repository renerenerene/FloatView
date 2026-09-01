// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FloatView",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "FloatView",
            path: "Sources/FloatView",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("UniformTypeIdentifiers")
            ]
        )
    ]
)
