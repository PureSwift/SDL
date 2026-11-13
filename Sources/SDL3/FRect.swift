//
//  FRect.swift
//  SDL3
//

import CSDL3

/// A rectangle, with the origin at the upper left, in floating point coordinates.
public struct SDLFRect: Equatable, Hashable, Sendable {

    public var x: Float
    public var y: Float
    public var width: Float
    public var height: Float

    public init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    internal var internalValue: SDL_FRect {
        SDL_FRect(x: x, y: y, w: width, h: height)
    }
}

/// A point in floating point coordinates.
public struct SDLFPoint: Equatable, Hashable, Sendable {

    public var x: Float
    public var y: Float

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }

    internal var internalValue: SDL_FPoint {
        SDL_FPoint(x: x, y: y)
    }
}
