// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISnapshotTestCase",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SwiftUISnapshotTestCase",
            targets: ["SwiftUISnapshotTestCase"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", from: "2.1.0")
        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", revision: "2471559a47e8435b162ef259d9727951efd4bc15")
    ],
    targets: [
        .target(
            name: "SwiftUISnapshotTestCase",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
