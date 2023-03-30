// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "InputMask",
    products: [
        .library(
            name: "InputMask",
            targets: ["InputMask"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "InputMask",
            dependencies: [],
            path: "Source/InputMask/InputMask",
            sources: ["Classes"]
        ),
        .testTarget(
            name: "InputMaskTests",
            dependencies: ["InputMask"],
            path: "Source/InputMask",
            sources: ["InputMaskTests/Classes"]
        ),
    ]
)
