//
//  Mouse.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL2

public extension SDL {

    /// The current state of the mouse, in window-relative coordinates.
    static var mouseState: (buttons: MouseButtonFlags, x: Int32, y: Int32) {

        var x: Int32 = 0
        var y: Int32 = 0
        let buttons = SDL_GetMouseState(&x, &y)
        return (MouseButtonFlags(rawValue: buttons), x, y)
    }

    /// The current state of the mouse, relative to the last call (or since event initialization).
    static var relativeMouseState: (buttons: MouseButtonFlags, x: Int32, y: Int32) {

        var x: Int32 = 0
        var y: Int32 = 0
        let buttons = SDL_GetRelativeMouseState(&x, &y)
        return (MouseButtonFlags(rawValue: buttons), x, y)
    }

    /// Whether relative mouse mode is enabled.
    ///
    /// - Note: Unlike SDL3, SDL2's relative mouse mode is a global setting, not per-window.
    static var relativeMouseMode: Bool {

        get { SDL_GetRelativeMouseMode() != SDL_FALSE }
    }

    /// Set relative mouse mode.
    static func setRelativeMouseMode(_ enabled: Bool) throws(SDLError) {

        try SDL_SetRelativeMouseMode(enabled ? SDL_TRUE : SDL_FALSE).sdlThrow(type: "SDL")
    }
}

public extension SDLWindow {

    /// Whether the window has grabbed mouse (and keyboard) input.
    var mouseGrab: Bool {
        SDL_GetWindowGrab(internalPointer) != SDL_FALSE
    }

    /// Set the window's mouse (and keyboard) grab mode.
    func setMouseGrab(_ grabbed: Bool) {
        SDL_SetWindowGrab(internalPointer, grabbed ? SDL_TRUE : SDL_FALSE)
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
