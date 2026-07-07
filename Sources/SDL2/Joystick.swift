//
//  Joystick.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL2

public extension SDL {

    /// The joystick instance IDs of the currently connected joysticks.
    ///
    /// - Note: Unlike SDL3, SDL2 enumerates joysticks by device index (`0 ..< numJoysticks`);
    ///   this maps each device index to its (stable) instance ID.
    static var joystickIDs: [JoystickID] {

        let count = max(0, SDL_NumJoysticks())
        return (0 ..< count).map { JoystickID(rawValue: SDL_JoystickGetDeviceInstanceID($0)) }
    }
}

public extension JoystickID {

    /// The implementation dependent name of the joystick, by device index.
    ///
    /// - Note: `deviceIndex` is the joystick's position in `0 ..< SDL.joystickIDs.count`,
    ///   not its instance ID.
    static func name(deviceIndex: Int32) -> String? {

        guard let cString = SDL_JoystickNameForIndex(deviceIndex) else { return nil }
        return String(cString: cString)
    }
}
