//
//  Rect.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

/// A rectangle, with the origin at the upper left, in integer coordinates.
public struct SDLRect: Equatable, Hashable, Sendable {

    public var x: Int32
    public var y: Int32
    public var width: Int32
    public var height: Int32

    public init(x: Int32, y: Int32, width: Int32, height: Int32) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    internal init(_ internalValue: SDL_Rect) {
        self.x = internalValue.x
        self.y = internalValue.y
        self.width = internalValue.w
        self.height = internalValue.h
    }

    internal var internalValue: SDL_Rect {
        SDL_Rect(x: x, y: y, w: width, h: height)
    }
}
