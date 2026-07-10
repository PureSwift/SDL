//
//  Keyboard.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

public extension SDL {

    /// Get a snapshot of the current state of the keyboard.
    ///
    /// - Returns: An array indexed by `SDLKeycode.rawValue`; `true` means the key is pressed.
    static func keyboardState() -> [Bool] {
        var count: CInt = 0
        guard let pointer = SDL_GetKeyState(&count), count > 0 else { return [] }
        return (0 ..< Int(count)).map { pointer[$0] != 0 }
    }

    /// The current state of the keyboard modifier keys.
    static var modifierState: BitMaskOptionSet<SDLKeyModifier> {
        get { BitMaskOptionSet<SDLKeyModifier>(rawValue: numericCast(SDL_GetModState().rawValue)) }
        set { SDL_SetModState(SDLMod(rawValue: numericCast(newValue.rawValue))) }
    }

    /// Enable keyboard repeat, or pass `nil` to disable it.
    static func enableKeyRepeat(delay: Int = Int(SDL_DEFAULT_REPEAT_DELAY), interval: Int = Int(SDL_DEFAULT_REPEAT_INTERVAL)) throws(SDLError) {
        try SDL_EnableKeyRepeat(CInt(delay), CInt(interval)).sdlThrow(type: "SDL")
    }

    /// Enable or disable Unicode translation of keyboard input.
    ///
    /// - Returns: The previous enabled state.
    @discardableResult
    static func enableUnicode(_ enabled: Bool) -> Bool {
        return SDL_EnableUNICODE(enabled ? 1 : 0) != 0
    }
}

// MARK: - Supporting Types

/// A virtual keyboard key symbol.
public struct SDLKeycode: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    internal init(_ key: SDLKey) {
        self.rawValue = numericCast(key.rawValue)
    }

    /// The human readable name of the key.
    public var name: String {
        return String(cString: SDL_GetKeyName(SDLKey(numericCast(rawValue))))
    }
}

public extension SDLKeycode {

    static var backspace: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_BACKSPACE.rawValue)) }
    static var tab: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_TAB.rawValue)) }
    static var `return`: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_RETURN.rawValue)) }
    static var escape: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_ESCAPE.rawValue)) }
    static var space: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_SPACE.rawValue)) }
    static var delete: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_DELETE.rawValue)) }

    static var up: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_UP.rawValue)) }
    static var down: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_DOWN.rawValue)) }
    static var left: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_LEFT.rawValue)) }
    static var right: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_RIGHT.rawValue)) }

    static var leftShift: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_LSHIFT.rawValue)) }
    static var rightShift: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_RSHIFT.rawValue)) }
    static var leftControl: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_LCTRL.rawValue)) }
    static var rightControl: SDLKeycode { SDLKeycode(rawValue: numericCast(SDLK_RCTRL.rawValue)) }
}

/// A keyboard modifier key.
public enum SDLKeyModifier: UInt32, BitMaskOption {

    case leftShift = 0x0001
    case rightShift = 0x0002
    case leftControl = 0x0040
    case rightControl = 0x0080
    case leftAlt = 0x0100
    case rightAlt = 0x0200
    case leftMeta = 0x0400
    case rightMeta = 0x0800
    case numLock = 0x1000
    case capsLock = 0x2000
    case mode = 0x4000
}
