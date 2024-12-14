// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SDL",
    products: [
        .library(
            name: "SDL",
            targets: ["SDL"]
        ),
        .executable(
            name: "SDLDemo",
            targets: ["SDLDemo"]
        )
    ],
    targets: [
        .executableTarget(
            name: "SDLDemo",
            dependencies: ["SDL"]
        ),
        .target(
            name: "SDL",
            dependencies: ["CSDL2"]
        ),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"])
            ]
        ),
        .testTarget(
            name: "SDLTests",
            dependencies: ["SDL"]),
        ]
)
