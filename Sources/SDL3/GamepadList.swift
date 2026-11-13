//
//  GamepadList.swift
//  SDL3
//

import CSDL3

public extension SDLGamepad {

    /// The connected gamepads' identifiers.
    static var connected: [JoystickID] {

        var count: Int32 = 0
        guard let pointer = SDL_GetGamepads(&count) else { return [] }
        defer { SDL_free(pointer) }
        return (0 ..< Int(count)).map { JoystickID(rawValue: pointer[$0]) }
    }

    /// Read the gamepads' state when their events are not being pumped.
    static func update() {
        SDL_UpdateGamepads()
    }
}
