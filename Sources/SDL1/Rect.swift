//
//  Rect.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// A rectangle, with the origin at the upper left.
public struct SDLRect: Equatable, Hashable, Sendable {

    public var x: Int16
    public var y: Int16
    public var width: UInt16
    public var height: UInt16

    public init(x: Int16, y: Int16, width: UInt16, height: UInt16) {
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
