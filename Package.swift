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
//        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", from: "2.2.2")
        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", revision: "ce4469dd0e4af935f8fe6a93fe210aff6162c6d2")
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
