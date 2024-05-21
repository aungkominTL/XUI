// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XUI",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(name: "XUI", targets: ["XUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "4.1.1"),
        .package(url: "https://github.com/kean/NukeUI", from: "0.8.3"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "XUI",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                .product(name: "NukeUI", package: "NukeUI"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
        .testTarget(
            name: "XUITests",
            dependencies: ["XUI"]),
    ]
)
