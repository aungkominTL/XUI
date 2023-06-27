// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XUI",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "XUI", targets: ["XUI"]),
        .library(name: "SFSafeSyymbols", targets: ["XUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "4.1.1"))
    ],
    targets: [
        .target(
            name: "XUI",
            dependencies: []),
        .testTarget(
            name: "XUITests",
            dependencies: ["XUI"]),
    ]
)
