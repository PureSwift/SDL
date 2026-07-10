//
//  Event.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

public extension SDL {

    /// Poll for currently pending events.
    ///
    /// - Returns: The next event in the queue, or `nil` if the queue is empty.
    static func pollEvent() -> SDLEvent? {

        var event = SDL_Event()
        guard SDL_PollEvent(&event) != 0 else { return nil }
        return SDLEvent(event)
    }

    /// Wait indefinitely for the next available event.
    ///
    /// - Returns: The next event, or `nil` if an error occurred while waiting.
    static func waitEvent() -> SDLEvent? {

        var event = SDL_Event()
        guard SDL_WaitEvent(&event) != 0 else { return nil }
        return SDLEvent(event)
    }
}

/// A polled SDL event.
public enum SDLEvent {

    case quit
    case active(gained: Bool, state: UInt8)
    case keyDown(key: SDLKeycode, scancode: UInt8, modifiers: BitMaskOptionSet<SDLKeyModifier>, unicode: UInt16)
    case keyUp(key: SDLKeycode, scancode: UInt8, modifiers: BitMaskOptionSet<SDLKeyModifier>, unicode: UInt16)
    case mouseMotion(x: UInt16, y: UInt16, relativeX: Int16, relativeY: Int16, state: UInt8)
    case mouseButtonDown(x: UInt16, y: UInt16, button: SDLMouseButton)
    case mouseButtonUp(x: UInt16, y: UInt16, button: SDLMouseButton)
    case joyAxisMotion(joystick: UInt8, axis: UInt8, value: Int16)
    case joyButtonDown(joystick: UInt8, button: UInt8)
    case joyButtonUp(joystick: UInt8, button: UInt8)
    case joyHatMotion(joystick: UInt8, hat: UInt8, value: UInt8)
    case videoResize(width: Int, height: Int)
    case videoExpose

    /// An event that isn't yet modeled by `SDLEvent`. The raw `SDL_EventType` value is preserved.
    case unknown(UInt8)

    internal init(_ event: SDL_Event) {

        switch SDL_EventType(rawValue: UInt32(event.type)) {

        case SDL_QUIT:
            self = .quit

        case SDL_ACTIVEEVENT:
            self = .active(gained: event.active.gain != 0, state: event.active.state)

        case SDL_KEYDOWN:
            self = .keyDown(
                key: SDLKeycode(event.key.keysym.sym),
                scancode: event.key.keysym.scancode,
                modifiers: BitMaskOptionSet<SDLKeyModifier>(rawValue: numericCast(event.key.keysym.mod.rawValue)),
                unicode: event.key.keysym.unicode
            )

        case SDL_KEYUP:
            self = .keyUp(
                key: SDLKeycode(event.key.keysym.sym),
                scancode: event.key.keysym.scancode,
                modifiers: BitMaskOptionSet<SDLKeyModifier>(rawValue: numericCast(event.key.keysym.mod.rawValue)),
                unicode: event.key.keysym.unicode
            )

        case SDL_MOUSEMOTION:
            self = .mouseMotion(x: event.motion.x, y: event.motion.y, relativeX: event.motion.xrel, relativeY: event.motion.yrel, state: event.motion.state)

        case SDL_MOUSEBUTTONDOWN:
            self = .mouseButtonDown(x: event.button.x, y: event.button.y, button: SDLMouseButton(rawValue: event.button.button))

        case SDL_MOUSEBUTTONUP:
            self = .mouseButtonUp(x: event.button.x, y: event.button.y, button: SDLMouseButton(rawValue: event.button.button))

        case SDL_JOYAXISMOTION:
            self = .joyAxisMotion(joystick: event.jaxis.which, axis: event.jaxis.axis, value: event.jaxis.value)

        case SDL_JOYBUTTONDOWN:
            self = .joyButtonDown(joystick: event.jbutton.which, button: event.jbutton.button)

        case SDL_JOYBUTTONUP:
            self = .joyButtonUp(joystick: event.jbutton.which, button: event.jbutton.button)

        case SDL_JOYHATMOTION:
            self = .joyHatMotion(joystick: event.jhat.which, hat: event.jhat.hat, value: event.jhat.value)

        case SDL_VIDEORESIZE:
            self = .videoResize(width: Int(event.resize.w), height: Int(event.resize.h))

        case SDL_VIDEOEXPOSE:
            self = .videoExpose

        default:
            self = .unknown(event.type)
        }
    }
}
