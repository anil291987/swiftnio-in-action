// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftnio-in-action",
    products: [
        .library(
            name: "chapter1",
            targets: ["chapter1"]),
        .library(
            name: "chapter2",
            targets: ["chapter2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.5.1")
    ],
    targets: [
        .target(
            name: "chapter1",
            dependencies: ["NIO"]),
        .target(
            name: "chapter2",
            dependencies: ["NIO"]),
        .testTarget(
            name: "chapter1Tests",
            dependencies: ["chapter1"]),
        .testTarget(
            name: "chapter2Tests",
            dependencies: ["chapter2"]),
    ]
)
