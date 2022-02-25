// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-http-client",
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
