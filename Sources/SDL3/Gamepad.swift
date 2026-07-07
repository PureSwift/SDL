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

    /// The implementation dependent name of the gamepad.
    public var name: String? {
        guard let cString = SDL_GetGamepadName(internalPointer) else { return nil }
        return String(cString: cString)
    }

    /// The properties associated with this gamepad.
    public var properties: SDLProperties {
        SDLProperties(rawValue: SDL_GetGamepadProperties(internalPointer))
    }

    /// Whether the gamepad has a rumble motor.
    public var hasRumble: Bool {
        properties.boolean(SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN)
    }

    /// Start a rumble effect on the gamepad.
    public func rumble(lowFrequency: UInt16, highFrequency: UInt16, duration milliseconds: UInt32) throws(SDLError) {
        try SDL_RumbleGamepad(internalPointer, lowFrequency, highFrequency, milliseconds).sdlThrow(type: "SDLGamepad")
    }

    /// Set the player index of the gamepad.
    public func setPlayerIndex(_ playerIndex: Int32) throws(SDLError) {
        try SDL_SetGamepadPlayerIndex(internalPointer, playerIndex).sdlThrow(type: "SDLGamepad")
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

public extension SDLGamepad.Axis {

    /// A human-readable name for the axis, or `nil` if it doesn't have one.
    var stringValue: String? {
        guard let cString = SDL_GetGamepadStringForAxis(SDL_GamepadAxis(rawValue: rawValue)) else { return nil }
        return String(cString: cString)
    }
}

public extension SDLGamepad.Button {

    /// A human-readable name for the button, or `nil` if it doesn't have one.
    var stringValue: String? {
        guard let cString = SDL_GetGamepadStringForButton(SDL_GamepadButton(rawValue: rawValue)) else { return nil }
        return String(cString: cString)
    }
}

public extension SDL {

    /// Add support for gamepads that SDL is unaware of, loading a mapping file.
    static func addGamepadMappings(fromFile path: String) throws(SDLError) -> Int32 {

        let count = SDL_AddGamepadMappingsFromFile(path)
        try (count >= 0).sdlThrow(type: "SDL")
        return count
    }

    /// Whether the given joystick is supported by the gamepad interface.
    static func isGamepad(_ joystickID: JoystickID) -> Bool {
        SDL_IsGamepad(joystickID.rawValue)
    }
}
