//
//  WindowState.swift
//  SDL3
//

import CSDL3

public extension SDLWindow {

    /// The window's properties, such as the platform's own handles for it.
    var properties: SDLProperties {
        SDLProperties(rawValue: SDL_GetWindowProperties(internalPointer))
    }

    /// The part of the window the system doesn't cover with a notch, a
    /// rounded corner or its own bars, in window coordinates.
    func safeArea() throws(SDLError) -> SDLRect {
        var rect = SDL_Rect()
        try SDL_GetWindowSafeArea(internalPointer, &rect).sdlThrow(type: "SDLWindow")
        return SDLRect(rect)
    }

    /// Whether the window has keyboard focus.
    var hasKeyboardFocus: Bool {
        SDL_GetKeyboardFocus() == internalPointer
    }
}

public extension SDL {

    /// The identifier of the window with keyboard focus, if one of the
    /// app's has it.
    static var keyboardFocusWindowID: UInt? {
        guard let window = SDL_GetKeyboardFocus() else { return nil }
        let id = SDL_GetWindowID(window)
        return id == 0 ? nil : UInt(id)
    }

    /// The properties SDL keeps for the whole process, such as the display
    /// server's connection.
    static var globalProperties: SDLProperties {
        SDLProperties(rawValue: SDL_GetGlobalProperties())
    }
}

public extension SDLProperties {

    /// Get a pointer property.
    func pointer(_ name: String) -> UnsafeMutableRawPointer? {
        SDL_GetPointerProperty(rawValue, name, nil)
    }

    /// Get a string property.
    func string(_ name: String) -> String? {
        SDL_GetStringProperty(rawValue, name, nil).map { String(cString: $0) }
    }

    /// Whether a property is set.
    func has(_ name: String) -> Bool {
        SDL_HasProperty(rawValue, name)
    }
}
