//
//  Joystick.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

public extension SDL {

    /// A list of currently connected joysticks.
    static var joystickIDs: [JoystickID] {

        var count: Int32 = 0
        guard let pointer = SDL_GetJoysticks(&count) else { return [] }
        defer { SDL_free(pointer) }
        return (0 ..< Int(count)).map { JoystickID(rawValue: pointer[$0]) }
    }
}

public extension JoystickID {

    /// The implementation dependent name of the joystick.
    var name: String? {

        guard let cString = SDL_GetJoystickNameForID(rawValue) else { return nil }
        return String(cString: cString)
    }
}
