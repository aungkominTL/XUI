// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XUI",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "XUI", targets: ["XUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "4.1.1"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.1.2")
    ],
    targets: [
        .target(
            name: "XUI",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                "Nuke", .product(name: "NukeUI", package: "Nuke")
            ]
        ),
        .testTarget(
            name: "XUITests",
            dependencies: ["XUI"]),
    ]
)
