// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCLI",
    dependencies: [
        .package(url: "https://github.com/facebook/yoga", branch: "main")
    ],
    targets: [
        .target(
            name: "Yoga",
            dependencies: [
                .product(name: "yoga", package: "yoga")
            ]
        ),
        .target(
            name: "CSkia",
            linkerSettings: [
                .unsafeFlags(["-L../skiasharp/out/AppleSilicon"]),
                .linkedLibrary("skia"),
                .linkedLibrary("skparagraph"),
                .linkedLibrary("skshaper"),
                .linkedLibrary("skunicode"),
                .linkedLibrary("SkiaSharp"),
                .linkedFramework("Cocoa"),
            ]
        ),
        .target(
            name: "Skia",
            dependencies: ["CSkia"]
        ),
        .systemLibrary(
            name: "CGLFW3",
            pkgConfig: "glfw3",
            providers: [.brew(["glfw"])]
        ),
        .target(
            name: "GLFW",
            dependencies: ["CGLFW3"]
        ),
        .target(
            name: "SUI",
            dependencies: ["GLFW", "Skia", "Yoga"]
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Demo",
            dependencies: ["SUI"]
        ),
    ]
)
