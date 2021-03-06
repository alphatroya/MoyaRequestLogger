// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoyaRequestLogger",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MoyaRequestLogger",
            targets: ["MoyaRequestLogger"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "13.0.0")),
    ],
    targets: [
        .target(
            name: "MoyaRequestLogger",
            dependencies: ["Moya"]
        ),
        .testTarget(
            name: "MoyaRequestLoggerTests",
            dependencies: ["MoyaRequestLogger"]
        ),
    ]
)
