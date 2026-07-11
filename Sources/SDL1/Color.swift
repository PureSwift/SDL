//
//  Color.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Color
///
/// A single color entry, as used by palettes. SDL 1.2 colors carry no alpha channel.
public struct SDLColor: Equatable, Hashable, Sendable {

    public var red: UInt8

    public var green: UInt8

    public var blue: UInt8

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    internal init(_ color: SDL_Color) {
        self.red = color.r
        self.green = color.g
        self.blue = color.b
    }

    internal var internalValue: SDL_Color {
        SDL_Color(r: red, g: green, b: blue, unused: 0)
    }
}
