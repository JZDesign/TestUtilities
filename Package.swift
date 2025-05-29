// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestUtilities",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(
            name: "TestUtilities",
            targets: ["TestUtilities"]),
    ],
    targets: [
        .target(
            name: "TestUtilities"),
        .testTarget(
            name: "TestUtilitiesTests",
            dependencies: ["TestUtilities"]
        ),
    ]
)
