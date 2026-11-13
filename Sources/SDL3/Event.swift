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

    /// Wait until the specified timeout for the next event.
    ///
    /// - Parameter milliseconds: The maximum time to wait; negative waits indefinitely.
    /// - Returns: The next event, or `nil` if the timeout elapsed first.
    static func waitEvent(timeout milliseconds: Int32) -> SDLEvent? {

        var event = SDL_Event()
        guard SDL_WaitEventTimeout(&event, milliseconds) else { return nil }
        return SDLEvent(event)
    }
}

/// A polled SDL event.
public enum SDLEvent {

    case quit
    case window(windowID: UInt32, event: Window)
    case mouseMotion(windowID: UInt32, which: MouseID, buttons: MouseButtonFlags, x: Float, y: Float, relativeX: Float, relativeY: Float)
    case mouseButtonDown(windowID: UInt32, which: MouseID, button: MouseButton, clicks: UInt8, x: Float, y: Float)
    case mouseButtonUp(windowID: UInt32, which: MouseID, button: MouseButton, clicks: UInt8, x: Float, y: Float)
    case mouseWheel(windowID: UInt32, which: MouseID, x: Float, y: Float, isFlipped: Bool, mouseX: Float, mouseY: Float)
    case keyDown(windowID: UInt32, scancode: Scancode, keycode: Keycode, modifiers: KeyModifiers, isRepeat: Bool)
    case keyUp(windowID: UInt32, scancode: Scancode, keycode: Keycode, modifiers: KeyModifiers, isRepeat: Bool)
    case textInput(windowID: UInt32, text: String)
    case fingerDown(windowID: UInt32, touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case fingerMotion(windowID: UInt32, touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case fingerUp(windowID: UInt32, touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case fingerCanceled(windowID: UInt32, touchID: TouchID, fingerID: FingerID, x: Float, y: Float)
    case gamepadAdded(which: JoystickID)
    case gamepadRemoved(which: JoystickID)
    case gamepadButtonDown(which: JoystickID, button: SDLGamepad.Button)
    case gamepadButtonUp(which: JoystickID, button: SDLGamepad.Button)

    /// An event that isn't yet modeled by `SDLEvent`. The raw `SDL_EventType` value is preserved.
    case unknown(UInt32)

    /// What happened to a window.
    public enum Window: Equatable, Sendable {
        case shown, hidden, exposed, minimized, maximized, restored
        case moved(x: Int32, y: Int32)
        case resized(width: Int32, height: Int32)
        case pixelSizeChanged(width: Int32, height: Int32)
        case focusGained, focusLost
        case closeRequested
    }

    internal init(_ event: SDL_Event) {

        func finger(_ make: (UInt32, TouchID, FingerID, Float, Float) -> SDLEvent) -> SDLEvent {
            let f = event.tfinger
            return make(f.windowID, TouchID(rawValue: f.touchID), FingerID(rawValue: f.fingerID), f.x, f.y)
        }

        switch SDL_EventType(rawValue: event.type) {

        case SDL_EVENT_QUIT:
            self = .quit

        case SDL_EVENT_WINDOW_SHOWN: self = .window(windowID: event.window.windowID, event: .shown)
        case SDL_EVENT_WINDOW_HIDDEN: self = .window(windowID: event.window.windowID, event: .hidden)
        case SDL_EVENT_WINDOW_EXPOSED: self = .window(windowID: event.window.windowID, event: .exposed)
        case SDL_EVENT_WINDOW_MINIMIZED: self = .window(windowID: event.window.windowID, event: .minimized)
        case SDL_EVENT_WINDOW_MAXIMIZED: self = .window(windowID: event.window.windowID, event: .maximized)
        case SDL_EVENT_WINDOW_RESTORED: self = .window(windowID: event.window.windowID, event: .restored)
        case SDL_EVENT_WINDOW_MOVED: self = .window(windowID: event.window.windowID, event: .moved(x: event.window.data1, y: event.window.data2))
        case SDL_EVENT_WINDOW_RESIZED: self = .window(windowID: event.window.windowID, event: .resized(width: event.window.data1, height: event.window.data2))
        case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED: self = .window(windowID: event.window.windowID, event: .pixelSizeChanged(width: event.window.data1, height: event.window.data2))
        case SDL_EVENT_WINDOW_FOCUS_GAINED: self = .window(windowID: event.window.windowID, event: .focusGained)
        case SDL_EVENT_WINDOW_FOCUS_LOST: self = .window(windowID: event.window.windowID, event: .focusLost)
        case SDL_EVENT_WINDOW_CLOSE_REQUESTED: self = .window(windowID: event.window.windowID, event: .closeRequested)

        case SDL_EVENT_MOUSE_MOTION:
            let m = event.motion
            self = .mouseMotion(windowID: m.windowID, which: MouseID(rawValue: m.which), buttons: MouseButtonFlags(rawValue: m.state),
                                x: m.x, y: m.y, relativeX: m.xrel, relativeY: m.yrel)

        case SDL_EVENT_MOUSE_BUTTON_DOWN:
            let b = event.button
            self = .mouseButtonDown(windowID: b.windowID, which: MouseID(rawValue: b.which), button: MouseButton(rawValue: b.button), clicks: b.clicks, x: b.x, y: b.y)

        case SDL_EVENT_MOUSE_BUTTON_UP:
            let b = event.button
            self = .mouseButtonUp(windowID: b.windowID, which: MouseID(rawValue: b.which), button: MouseButton(rawValue: b.button), clicks: b.clicks, x: b.x, y: b.y)

        case SDL_EVENT_MOUSE_WHEEL:
            let w = event.wheel
            self = .mouseWheel(windowID: w.windowID, which: MouseID(rawValue: w.which), x: w.x, y: w.y,
                               isFlipped: w.direction == SDL_MOUSEWHEEL_FLIPPED, mouseX: w.mouse_x, mouseY: w.mouse_y)

        case SDL_EVENT_KEY_DOWN:
            let k = event.key
            self = .keyDown(windowID: k.windowID, scancode: Scancode(rawValue: k.scancode.rawValue), keycode: Keycode(rawValue: k.key),
                            modifiers: KeyModifiers(rawValue: k.mod), isRepeat: k.repeat)

        case SDL_EVENT_KEY_UP:
            let k = event.key
            self = .keyUp(windowID: k.windowID, scancode: Scancode(rawValue: k.scancode.rawValue), keycode: Keycode(rawValue: k.key),
                          modifiers: KeyModifiers(rawValue: k.mod), isRepeat: k.repeat)

        case SDL_EVENT_TEXT_INPUT:
            self = .textInput(windowID: event.text.windowID, text: event.text.text.map { String(cString: $0) } ?? "")

        case SDL_EVENT_FINGER_DOWN: self = finger { .fingerDown(windowID: $0, touchID: $1, fingerID: $2, x: $3, y: $4) }
        case SDL_EVENT_FINGER_MOTION: self = finger { .fingerMotion(windowID: $0, touchID: $1, fingerID: $2, x: $3, y: $4) }
        case SDL_EVENT_FINGER_UP: self = finger { .fingerUp(windowID: $0, touchID: $1, fingerID: $2, x: $3, y: $4) }
        case SDL_EVENT_FINGER_CANCELED: self = finger { .fingerCanceled(windowID: $0, touchID: $1, fingerID: $2, x: $3, y: $4) }

        case SDL_EVENT_GAMEPAD_ADDED:
            self = .gamepadAdded(which: JoystickID(rawValue: event.gdevice.which))

        case SDL_EVENT_GAMEPAD_REMOVED:
            self = .gamepadRemoved(which: JoystickID(rawValue: event.gdevice.which))

        case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
            self = .gamepadButtonDown(which: JoystickID(rawValue: event.gbutton.which), button: SDLGamepad.Button(rawValue: Int32(event.gbutton.button)))

        case SDL_EVENT_GAMEPAD_BUTTON_UP:
            self = .gamepadButtonUp(which: JoystickID(rawValue: event.gbutton.which), button: SDLGamepad.Button(rawValue: Int32(event.gbutton.button)))

        default:
            self = .unknown(event.type)
        }
    }
}

/// The keyboard modifiers held with a key.
public struct KeyModifiers: OptionSet, Sendable {

    public let rawValue: UInt16

    public init(rawValue: UInt16) { self.rawValue = rawValue }

    public static var leftShift: KeyModifiers { KeyModifiers(rawValue: 0x0001) }
    public static var rightShift: KeyModifiers { KeyModifiers(rawValue: 0x0002) }
    public static var leftControl: KeyModifiers { KeyModifiers(rawValue: 0x0040) }
    public static var rightControl: KeyModifiers { KeyModifiers(rawValue: 0x0080) }
    public static var leftAlt: KeyModifiers { KeyModifiers(rawValue: 0x0100) }
    public static var rightAlt: KeyModifiers { KeyModifiers(rawValue: 0x0200) }
    public static var leftGUI: KeyModifiers { KeyModifiers(rawValue: 0x0400) }
    public static var rightGUI: KeyModifiers { KeyModifiers(rawValue: 0x0800) }
    public static var numLock: KeyModifiers { KeyModifiers(rawValue: 0x1000) }
    public static var capsLock: KeyModifiers { KeyModifiers(rawValue: 0x2000) }

    public static var shift: KeyModifiers { [.leftShift, .rightShift] }
    public static var control: KeyModifiers { [.leftControl, .rightControl] }
    public static var alt: KeyModifiers { [.leftAlt, .rightAlt] }
    public static var gui: KeyModifiers { [.leftGUI, .rightGUI] }
}

public extension SDL {

    /// The keyboard modifiers currently held.
    static var modifierState: KeyModifiers { KeyModifiers(rawValue: SDL_GetModState()) }
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
