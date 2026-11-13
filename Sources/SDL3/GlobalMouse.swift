//
//  GlobalMouse.swift
//  SDL3
//

import CSDL3

public extension SDL {

    /// The mouse's position and buttons in screen coordinates.
    static var globalMouseState: (buttons: MouseButtonFlags, x: Float, y: Float) {

        var x: Float = 0
        var y: Float = 0
        let buttons = SDL_GetGlobalMouseState(&x, &y)
        return (MouseButtonFlags(rawValue: buttons), x, y)
    }

    /// Move the mouse cursor to a position in screen coordinates.
    static func warpMouse(toGlobal point: (x: Float, y: Float)) throws(SDLError) {
        try SDL_WarpMouseGlobal(point.x, point.y).sdlThrow(type: "SDL")
    }
}
