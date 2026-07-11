//
//  Mouse.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

public extension SDL {

    /// The current state of the mouse.
    static var mouseState: MouseState {
        var x: CInt = 0
        var y: CInt = 0
        let buttons = SDL_GetMouseState(&x, &y)
        return MouseState(x: Int(x), y: Int(y), buttons: buttons)
    }

    /// The current relative state of the mouse, i.e. the change since the last query.
    static var relativeMouseState: MouseState {
        var x: CInt = 0
        var y: CInt = 0
        let buttons = SDL_GetRelativeMouseState(&x, &y)
        return MouseState(x: Int(x), y: Int(y), buttons: buttons)
    }

    /// Move the mouse cursor to the given position within the window.
    static func warpMouse(x: Int, y: Int) {
        SDL_WarpMouse(UInt16(x), UInt16(y))
    }

    /// Whether the mouse cursor is shown.
    static var isCursorVisible: Bool {
        get { SDL_ShowCursor(-1) == 1 } // SDL_QUERY
        set { _ = SDL_ShowCursor(newValue ? 1 : 0) }
    }
}

// MARK: - Supporting Types

public extension SDL {

    /// A snapshot of the mouse position and button state.
    struct MouseState: Equatable, Hashable, Sendable {

        public let x: Int

        public let y: Int

        internal let buttons: UInt8

        internal init(x: Int, y: Int, buttons: UInt8) {
            self.x = x
            self.y = y
            self.buttons = buttons
        }

        /// Whether the given button is currently pressed.
        public func isPressed(_ button: SDLMouseButton) -> Bool {
            let mask = UInt8(1) << (button.rawValue - 1)
            return (buttons & mask) != 0
        }
    }
}

/// A mouse button index.
public struct SDLMouseButton: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static var left: SDLMouseButton { SDLMouseButton(rawValue: 1) }
    public static var middle: SDLMouseButton { SDLMouseButton(rawValue: 2) }
    public static var right: SDLMouseButton { SDLMouseButton(rawValue: 3) }
    public static var wheelUp: SDLMouseButton { SDLMouseButton(rawValue: 4) }
    public static var wheelDown: SDLMouseButton { SDLMouseButton(rawValue: 5) }
}
