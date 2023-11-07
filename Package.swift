// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventKit",
    platforms: [.macOS(.v13), .iOS(.v14), .tvOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "AdventKit", targets: ["AdventKit"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", branch: "release/1.1")
    ],
    targets: [
        .target(name: "AdventKit",
                dependencies: [
                    .product(name: "Collections", package: "swift-collections")
                ],
                path: "Sources"),
        .testTarget(name: "AdventKitTests", dependencies: ["AdventKit"], path: "Tests")
    ]
)
