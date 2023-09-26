// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Strings",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "Strings",
            targets: ["Strings"]),
        .library(
            name: "Utilities",
            targets: ["Utilities"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
    ],
    targets: [
        .executableTarget(
            name: "Strings",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "PathKit",
                "Rainbow",
                "Utilities",
            ],
            path: "Sources/Strings"
        ),
        .target(
            name: "Utilities",
            dependencies: [
                "PathKit",
                "Rainbow",
                "Yams"
            ]
        )
    ]
)
