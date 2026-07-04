//
//  Gamepad.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Gamepad
public final class SDLGamepad: Identifiable {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        SDL_GameControllerClose(internalPointer)
    }

    /// Open a gamepad for use.
    ///
    /// - Note: On SDL2, `joystickID` should be the device index reported by the
    ///   `.gamepadAdded` event, not the instance id used by other events.
    public init(joystickID: JoystickID) throws(SDLError) {

        let internalPointer = SDL_GameControllerOpen(Int32(joystickID.rawValue))
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLGamepad")
    }

    // MARK: - Accessors

    /// The joystick instance ID of this gamepad.
    public var id: JoystickID {
        let joystick = SDL_GameControllerGetJoystick(internalPointer)
        return JoystickID(rawValue: SDL_JoystickInstanceID(joystick))
    }

    // MARK: - Methods

    /// The current state of an axis control on a gamepad.
    public func axis(_ axis: Axis) -> Int16 {
        SDL_GameControllerGetAxis(internalPointer, SDL_GameControllerAxis(rawValue: axis.rawValue))
    }

    /// Whether a button on a gamepad is pressed.
    public func isPressed(_ button: Button) -> Bool {
        SDL_GameControllerGetButton(internalPointer, SDL_GameControllerButton(rawValue: button.rawValue)) != 0
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

        public static var leftX: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_LEFTX.rawValue) }
        public static var leftY: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_LEFTY.rawValue) }
        public static var rightX: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_RIGHTX.rawValue) }
        public static var rightY: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_RIGHTY.rawValue) }
        public static var leftTrigger: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_TRIGGERLEFT.rawValue) }
        public static var rightTrigger: Axis { Axis(rawValue: SDL_CONTROLLER_AXIS_TRIGGERRIGHT.rawValue) }
    }
}

public extension SDLGamepad {

    /// A gamepad button.
    struct Button: RawRepresentable, Equatable, Hashable, Sendable {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static var south: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_A.rawValue) }
        public static var east: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_B.rawValue) }
        public static var west: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_X.rawValue) }
        public static var north: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_Y.rawValue) }
        public static var back: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_BACK.rawValue) }
        public static var guide: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_GUIDE.rawValue) }
        public static var start: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_START.rawValue) }
        public static var leftStick: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_LEFTSTICK.rawValue) }
        public static var rightStick: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_RIGHTSTICK.rawValue) }
        public static var leftShoulder: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_LEFTSHOULDER.rawValue) }
        public static var rightShoulder: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_RIGHTSHOULDER.rawValue) }
        public static var dpadUp: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_DPAD_UP.rawValue) }
        public static var dpadDown: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_DPAD_DOWN.rawValue) }
        public static var dpadLeft: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_DPAD_LEFT.rawValue) }
        public static var dpadRight: Button { Button(rawValue: SDL_CONTROLLER_BUTTON_DPAD_RIGHT.rawValue) }
    }
}
