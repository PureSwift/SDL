//
//  Event.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

public extension SDL {

    /// Poll for currently pending events.
    ///
    /// - Returns: The next event in the queue, or `nil` if the queue is empty.
    static func pollEvent() -> SDLEvent? {

        var event = SDL_Event()
        guard SDL_PollEvent(&event) else { return nil }
        return SDLEvent(event)
    }
}

/// A polled SDL event.
public enum SDLEvent {

    case quit
    case mouseButtonDown(windowID: UInt32, x: Float, y: Float, button: MouseButton)
    case mouseButtonUp(windowID: UInt32, x: Float, y: Float, button: MouseButton)
    case mouseMotion(windowID: UInt32, x: Float, y: Float, which: MouseID)
    case keyDown(scancode: Scancode, keycode: Keycode)
    case keyUp(scancode: Scancode, keycode: Keycode)
    case windowResized(windowID: UInt32, width: Int32, height: Int32)
    case fingerDown(touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case fingerMotion(touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case gamepadAdded(which: JoystickID)
    case gamepadRemoved(which: JoystickID)
    case gamepadButtonDown(which: JoystickID, button: SDLGamepad.Button)
    case gamepadButtonUp(which: JoystickID, button: SDLGamepad.Button)
    case mouseWheel(windowID: UInt32, x: Float, y: Float)
    case textInput(windowID: UInt32, text: String)
    case windowCloseRequested(windowID: UInt32)

    /// An event that isn't yet modeled by `SDLEvent`. The raw `SDL_EventType` value is preserved.
    case unknown(UInt32)

    internal init(_ event: SDL_Event) {

        switch SDL_EventType(rawValue: event.type) {

        case SDL_EVENT_QUIT:
            self = .quit

        case SDL_EVENT_MOUSE_BUTTON_DOWN:
            self = .mouseButtonDown(windowID: event.button.windowID, x: event.button.x, y: event.button.y, button: MouseButton(rawValue: event.button.button))

        case SDL_EVENT_MOUSE_BUTTON_UP:
            self = .mouseButtonUp(windowID: event.button.windowID, x: event.button.x, y: event.button.y, button: MouseButton(rawValue: event.button.button))

        case SDL_EVENT_MOUSE_MOTION:
            self = .mouseMotion(windowID: event.motion.windowID, x: event.motion.x, y: event.motion.y, which: MouseID(rawValue: event.motion.which))

        case SDL_EVENT_KEY_DOWN:
            self = .keyDown(scancode: Scancode(rawValue: event.key.scancode.rawValue), keycode: Keycode(rawValue: event.key.key))

        case SDL_EVENT_KEY_UP:
            self = .keyUp(scancode: Scancode(rawValue: event.key.scancode.rawValue), keycode: Keycode(rawValue: event.key.key))

        case SDL_EVENT_WINDOW_RESIZED:
            self = .windowResized(windowID: event.window.windowID, width: event.window.data1, height: event.window.data2)

        case SDL_EVENT_FINGER_DOWN:
            self = .fingerDown(touchID: TouchID(rawValue: event.tfinger.touchID), fingerID: FingerID(rawValue: event.tfinger.fingerID), x: event.tfinger.x, y: event.tfinger.y)

        case SDL_EVENT_FINGER_MOTION:
            self = .fingerMotion(touchID: TouchID(rawValue: event.tfinger.touchID), fingerID: FingerID(rawValue: event.tfinger.fingerID), x: event.tfinger.x, y: event.tfinger.y)

        case SDL_EVENT_GAMEPAD_ADDED:
            self = .gamepadAdded(which: JoystickID(rawValue: event.gdevice.which))

        case SDL_EVENT_GAMEPAD_REMOVED:
            self = .gamepadRemoved(which: JoystickID(rawValue: event.gdevice.which))

        case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
            self = .gamepadButtonDown(which: JoystickID(rawValue: event.gbutton.which), button: SDLGamepad.Button(rawValue: Int32(event.gbutton.button)))

        case SDL_EVENT_GAMEPAD_BUTTON_UP:
            self = .gamepadButtonUp(which: JoystickID(rawValue: event.gbutton.which), button: SDLGamepad.Button(rawValue: Int32(event.gbutton.button)))

        case SDL_EVENT_MOUSE_WHEEL:
            self = .mouseWheel(windowID: event.wheel.windowID, x: event.wheel.x, y: event.wheel.y)

        case SDL_EVENT_TEXT_INPUT:
            self = .textInput(windowID: event.text.windowID, text: String(cString: event.text.text))

        case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
            self = .windowCloseRequested(windowID: event.window.windowID)

        default:
            self = .unknown(event.type)
        }
    }
}

// MARK: - Supporting Types

/// A mouse button index.
public struct MouseButton: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static var left: MouseButton { MouseButton(rawValue: UInt8(SDL_BUTTON_LEFT)) }
    public static var middle: MouseButton { MouseButton(rawValue: UInt8(SDL_BUTTON_MIDDLE)) }
    public static var right: MouseButton { MouseButton(rawValue: UInt8(SDL_BUTTON_RIGHT)) }
    public static var x1: MouseButton { MouseButton(rawValue: UInt8(SDL_BUTTON_X1)) }
    public static var x2: MouseButton { MouseButton(rawValue: UInt8(SDL_BUTTON_X2)) }
}

/// A mouse instance identifier.
public struct MouseID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// The `which` value reported for touch-originated mouse events.
    public static var touch: MouseID { MouseID(rawValue: .max) }
}

/// A physical keyboard scancode.
public struct Scancode: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

/// A virtual keyboard keycode.
public struct Keycode: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

/// A touch device identifier.
public struct TouchID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

/// A finger identifier.
public struct FingerID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

/// A joystick (and gamepad) instance identifier.
public struct JoystickID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}
