// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SDL",
    products: [
        .library(
            name: "SDL1Swift",
            targets: ["SDL1Swift"]
        ),
        .library(
            name: "SDL2Swift",
            targets: ["SDL2Swift"]
        ),
        .library(
            name: "SDL3Swift",
            targets: ["SDL3Swift"]
        ),
        .library(
            name: "SDL2Image",
            targets: ["SDL2Image"]
        ),
        .library(
            name: "SDL2Mixer",
            targets: ["SDL2Mixer"]
        ),
        .library(
            name: "SDL3Image",
            targets: ["SDL3Image"]
        ),
        .library(
            name: "SDL3Mixer",
            targets: ["SDL3Mixer"]
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
        // Named `SDL1Swift` (not `SDL1`) so the built module doesn't share a name
        // with the `SDL` system library, which would shadow `-lSDL` when linking.
        .target(
            name: "SDL1Swift",
            dependencies: ["CSDL"],
            path: "Sources/SDL1"
        ),
        .systemLibrary(
            name: "CSDL",
            pkgConfig: "sdl",
            providers: [
                .brew(["sdl12-compat"]),
                .apt(["libsdl1.2-dev"])
            ]
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
        // Separate, opt-in targets: consumers that don't need image loading or audio playback
        // don't pay for (or need to install) SDL_image / SDL_mixer at all.
        .target(
            name: "SDL2Image",
            dependencies: ["SDL2Swift", "CSDL2Image"],
            path: "Sources/SDL2Image"
        ),
        .target(
            name: "SDL2Mixer",
            dependencies: ["SDL2Swift", "CSDL2Mixer"],
            path: "Sources/SDL2Mixer"
        ),
        .target(
            name: "SDL3Image",
            dependencies: ["SDL3Swift", "CSDL3Image"],
            path: "Sources/SDL3Image"
        ),
        .target(
            name: "SDL3Mixer",
            dependencies: ["SDL3Swift", "CSDL3Mixer"],
            path: "Sources/SDL3Mixer"
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
            name: "SDL1Tests",
            dependencies: ["SDL1Swift"]),
        .testTarget(
            name: "SDL2Tests",
            dependencies: ["SDL2Swift"]),
        .testTarget(
            name: "SDL3Tests",
            dependencies: ["SDL3Swift"]),
        ]
)
