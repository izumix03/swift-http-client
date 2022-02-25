// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-http-client",
    products: [
        .library(
            name: "swift-http-client",
            targets: ["swift-http-client"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "swift-http-client",
            dependencies: []),
        .testTarget(
            name: "swift-http-clientTests",
            dependencies: ["swift-http-client"]),
    ]
)
