// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetworkMonitoringService",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "NetworkMonitoringService",
      targets: ["NetworkMonitoringService"]),
  ],
  targets: [
    .target(
      name: "NetworkMonitoringService"),
    .testTarget(
      name: "NetworkMonitoringServiceTests",
      dependencies: ["NetworkMonitoringService"]),
  ]
)
