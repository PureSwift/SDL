//
//  Touch.swift
//  SDL3
//

import CSDL3

/// What kind of device touches come from.
public enum SDLTouchDeviceType: Equatable, Hashable, Sendable {

    /// Not a touch device SDL knows of.
    case invalid

    /// A touch screen, whose coordinates are the window's.
    case direct

    /// A trackpad, whose coordinates are its own surface's.
    case indirectAbsolute

    /// A trackpad, whose coordinates are the screen cursor's.
    case indirectRelative
}

public extension TouchID {

    /// The kind of device the touches come from.
    var deviceType: SDLTouchDeviceType {
        switch SDL_GetTouchDeviceType(rawValue) {
        case SDL_TOUCH_DEVICE_DIRECT: .direct
        case SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE: .indirectAbsolute
        case SDL_TOUCH_DEVICE_INDIRECT_RELATIVE: .indirectRelative
        default: .invalid
        }
    }
}
