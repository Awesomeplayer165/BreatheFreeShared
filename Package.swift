// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreatheShared",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BreatheShared",
            targets: ["BreatheShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/GEOSwift/GEOSwift", .upToNextMajor(from: "10.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BreatheShared", dependencies: ["Alamofire", "GEOSwift"]),
        .testTarget(
            name: "BreatheSharedTests",
            dependencies: ["BreatheShared"]),
    ]
)
