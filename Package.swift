// swift-tools-version:4.0

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
            path: "Source/InputMask",
            exclude: ["InputMask/Classes/View"],
            sources: ["InputMask/Classes"]
        ),
        .testTarget(
            name: "InputMaskTests",
            dependencies: ["InputMask"],
            path: "Source/InputMask",
            sources: ["InputMaskTests/Classes"]
        ),
    ]
)
