// swift-tools-version:5.5
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
        .package(url: "https://github.com/urlaunched-com/swift-snapshot-testing.git", .exact("1.9.18")),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", .exact("0.1.3"))
    ],
    targets: [
        .target(
            name: "SwiftUISnapshotTestCase",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Introspect", package: "SwiftUI-Introspect")
            ]
        )
    ]
)
