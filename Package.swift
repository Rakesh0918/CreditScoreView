// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreditScoreView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CreditScoreView",
            targets: ["CreditScoreView"]
        ),
    ],
    targets: [
        .target(
            name: "CreditScoreView",
            dependencies: []
        ),
        .testTarget(
            name: "CreditScoreViewTests",
            dependencies: ["CreditScoreView"]
        ),
    ]
)
