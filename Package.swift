// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-http-client",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "HttpClient",
      targets: ["HttpClient"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "HttpClient",
      dependencies: []),
    .testTarget(
      name: "HttpClientTests",
      dependencies: ["HttpClient"]),
  ]
)
