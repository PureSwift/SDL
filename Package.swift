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
        .library(
            name: "CSDL2Image",
            targets: ["CSDL2Image"]
        ),
        .library(
            name: "CSDL2Mixer",
            targets: ["CSDL2Mixer"]
        ),
        .library(
            name: "CSDL3Image",
            targets: ["CSDL3Image"]
        ),
        .library(
            name: "CSDL3Mixer",
            targets: ["CSDL3Mixer"]
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
        .systemLibrary(
            name: "CSDL2Image",
            pkgConfig: "SDL2_image",
            providers: [
                .brew(["sdl2_image"]),
                .apt(["libsdl2-image-dev"])
            ]
        ),
        .systemLibrary(
            name: "CSDL2Mixer",
            pkgConfig: "SDL2_mixer",
            providers: [
                .brew(["sdl2_mixer"]),
                .apt(["libsdl2-mixer-dev"])
            ]
        ),
        .systemLibrary(
            name: "CSDL3Image",
            pkgConfig: "sdl3-image",
            providers: [
                .brew(["sdl3_image"]),
                .apt(["libsdl3-image-dev"])
            ]
        ),
        .systemLibrary(
            name: "CSDL3Mixer",
            pkgConfig: "sdl3-mixer",
            providers: [
                .brew(["sdl3_mixer"]),
                .apt(["libsdl3-mixer-dev"])
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
