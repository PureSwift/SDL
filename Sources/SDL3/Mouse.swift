//
//  Mouse.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

public extension SDL {

    /// The current state of the mouse, in window-relative coordinates.
    static var mouseState: (buttons: MouseButtonFlags, x: Float, y: Float) {

        var x: Float = 0
        var y: Float = 0
        let buttons = SDL_GetMouseState(&x, &y)
        return (MouseButtonFlags(rawValue: buttons), x, y)
    }

    /// The current state of the mouse, relative to the last call (or since event initialization).
    static var relativeMouseState: (buttons: MouseButtonFlags, x: Float, y: Float) {

        var x: Float = 0
        var y: Float = 0
        let buttons = SDL_GetRelativeMouseState(&x, &y)
        return (MouseButtonFlags(rawValue: buttons), x, y)
    }
}

public extension SDLWindow {

    /// Whether relative mouse mode is enabled for the window.
    var relativeMouseMode: Bool {

        get { SDL_GetWindowRelativeMouseMode(internalPointer) }
    }

    /// Set relative mouse mode for the window.
    func setRelativeMouseMode(_ enabled: Bool) throws(SDLError) {

        try SDL_SetWindowRelativeMouseMode(internalPointer, enabled).sdlThrow(type: "SDLWindow")
    }

    /// Set the window's mouse grab mode.
    func setMouseGrab(_ grabbed: Bool) throws(SDLError) {

        try SDL_SetWindowMouseGrab(internalPointer, grabbed).sdlThrow(type: "SDLWindow")
    }
}

// MARK: - Supporting Types

/// A bitmask of pressed mouse buttons, as reported by `SDL.mouseState`.
public struct MouseButtonFlags: OptionSet, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static var left: MouseButtonFlags { MouseButtonFlags(rawValue: 1 << (0)) }
    public static var middle: MouseButtonFlags { MouseButtonFlags(rawValue: 1 << (1)) }
    public static var right: MouseButtonFlags { MouseButtonFlags(rawValue: 1 << (2)) }
    public static var x1: MouseButtonFlags { MouseButtonFlags(rawValue: 1 << (3)) }
    public static var x2: MouseButtonFlags { MouseButtonFlags(rawValue: 1 << (4)) }
}
