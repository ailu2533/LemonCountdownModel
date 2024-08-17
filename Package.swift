// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LemonCountdownModel",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LemonCountdownModel",
            targets: ["LemonCountdownModel"])
    ],
    dependencies: [
        .package(url: "https://github.com/vinhnx/Shift.git", .upToNextMajor(from: "0.11.0")),
        .package(url: "https://github.com/ailu2533/LemonDateUtils.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.2")),
        .package(url: "https://github.com/ailu2533/SwiftMovable.git", branch: "main"),
        .package(url: "https://github.com/Boris-Em/ColorKit.git", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LemonCountdownModel",
            dependencies: [
                .product(name: "Shift", package: "Shift"),
                .product(name: "LemonDateUtils", package: "LemonDateUtils"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "SwiftMovable", package: "SwiftMovable"),
                .product(name: "ColorKit", package: "ColorKit")
            ]
        ),
        .testTarget(
            name: "LemonCountdownModelTests",
            dependencies: ["LemonCountdownModel"])
    ]
)
