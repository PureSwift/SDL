//
//  Gamepad.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

/// SDL Gamepad
public final class SDLGamepad: Identifiable {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        SDL_CloseGamepad(internalPointer)
    }

    /// Open a gamepad for use.
    public init(joystickID: JoystickID) throws(SDLError) {

        let internalPointer = SDL_OpenGamepad(joystickID.rawValue)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLGamepad")
    }

    // MARK: - Accessors

    /// The joystick instance ID of this gamepad.
    public var id: JoystickID {
        JoystickID(rawValue: SDL_GetGamepadID(internalPointer))
    }

    // MARK: - Methods

    /// The current state of an axis control on a gamepad.
    public func axis(_ axis: Axis) -> Int16 {
        SDL_GetGamepadAxis(internalPointer, SDL_GamepadAxis(rawValue: axis.rawValue))
    }

    /// Whether a button on a gamepad is pressed.
    public func isPressed(_ button: Button) -> Bool {
        SDL_GetGamepadButton(internalPointer, SDL_GamepadButton(rawValue: button.rawValue))
    }
}

// MARK: - Supporting Types

public extension SDLGamepad {

    /// A gamepad axis.
    struct Axis: RawRepresentable, Equatable, Hashable, Sendable {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static var leftX: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_LEFTX.rawValue) }
        public static var leftY: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_LEFTY.rawValue) }
        public static var rightX: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_RIGHTX.rawValue) }
        public static var rightY: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_RIGHTY.rawValue) }
        public static var leftTrigger: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_LEFT_TRIGGER.rawValue) }
        public static var rightTrigger: Axis { Axis(rawValue: SDL_GAMEPAD_AXIS_RIGHT_TRIGGER.rawValue) }
    }
}

public extension SDLGamepad {

    /// A gamepad button.
    struct Button: RawRepresentable, Equatable, Hashable, Sendable {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static var south: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_SOUTH.rawValue) }
        public static var east: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_EAST.rawValue) }
        public static var west: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_WEST.rawValue) }
        public static var north: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_NORTH.rawValue) }
        public static var back: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_BACK.rawValue) }
        public static var guide: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_GUIDE.rawValue) }
        public static var start: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_START.rawValue) }
        public static var leftStick: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_LEFT_STICK.rawValue) }
        public static var rightStick: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_RIGHT_STICK.rawValue) }
        public static var leftShoulder: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_LEFT_SHOULDER.rawValue) }
        public static var rightShoulder: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER.rawValue) }
        public static var dpadUp: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_DPAD_UP.rawValue) }
        public static var dpadDown: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_DPAD_DOWN.rawValue) }
        public static var dpadLeft: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_DPAD_LEFT.rawValue) }
        public static var dpadRight: Button { Button(rawValue: SDL_GAMEPAD_BUTTON_DPAD_RIGHT.rawValue) }
    }
}
