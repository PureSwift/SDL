// swift-tools-version:3.0.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDL",
    targets: [
                 Target(
                    name: "SDLDemo",
                    dependencies: [.Target(name: "SDL")]
					),
                 Target(
                    name: "SDL"
					)
    ],
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CSDL2.git", majorVersion: 1)
    ]
)
