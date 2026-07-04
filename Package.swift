// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SDL",
    products: [
        .library(
            name: "SDL2Swift",
            targets: ["SDL2Swift"]
        ),
        .library(
            name: "SDL3Swift",
            targets: ["SDL3Swift"]
        ),
        .executable(
            name: "SDLDemo",
            targets: ["SDLDemo"]
        )
    ],
    targets: [
        .executableTarget(
            name: "SDLDemo",
            dependencies: ["SDL2Swift"]
        ),
        // Named `SDL2Swift` (not `SDL2`) so the built module doesn't share a name
        // with the `SDL2` system library, which would shadow `-lSDL2` when linking.
        .target(
            name: "SDL2Swift",
            dependencies: ["CSDL2"],
            path: "Sources/SDL2"
        ),
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"])
            ]
        ),
        // Named `SDL3Swift` for the same reason as `SDL2Swift` above.
        .target(
            name: "SDL3Swift",
            dependencies: ["CSDL3"],
            path: "Sources/SDL3"
        ),
        .systemLibrary(
            name: "CSDL3",
            pkgConfig: "sdl3",
            providers: [
                .brew(["sdl3"]),
                .apt(["libsdl3-dev"])
            ]
        ),
        .testTarget(
            name: "SDL2Tests",
            dependencies: ["SDL2Swift"]),
        .testTarget(
            name: "SDL3Tests",
            dependencies: ["SDL3Swift"]),
        ]
)
