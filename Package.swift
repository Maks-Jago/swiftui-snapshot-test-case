// swift-tools-version:5.4
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
        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", .exact("1.9.29"))
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
