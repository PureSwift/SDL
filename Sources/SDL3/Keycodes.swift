//
//  Keycodes.swift
//  SDL3
//

import CSDL3

/// The keys an app's interface responds to. A key that types a character
/// has that character's Unicode scalar as its code.
public extension Keycode {

    static var `return`: Keycode { Keycode(rawValue: SDLK_RETURN) }
    static var keypadEnter: Keycode { Keycode(rawValue: SDLK_KP_ENTER) }
    static var escape: Keycode { Keycode(rawValue: SDLK_ESCAPE) }
    static var backspace: Keycode { Keycode(rawValue: SDLK_BACKSPACE) }
    static var tab: Keycode { Keycode(rawValue: SDLK_TAB) }
    static var space: Keycode { Keycode(rawValue: SDLK_SPACE) }
    static var delete: Keycode { Keycode(rawValue: SDLK_DELETE) }
    static var insert: Keycode { Keycode(rawValue: SDLK_INSERT) }

    static var left: Keycode { Keycode(rawValue: SDLK_LEFT) }
    static var right: Keycode { Keycode(rawValue: SDLK_RIGHT) }
    static var up: Keycode { Keycode(rawValue: SDLK_UP) }
    static var down: Keycode { Keycode(rawValue: SDLK_DOWN) }
    static var home: Keycode { Keycode(rawValue: SDLK_HOME) }
    static var end: Keycode { Keycode(rawValue: SDLK_END) }
    static var pageUp: Keycode { Keycode(rawValue: SDLK_PAGEUP) }
    static var pageDown: Keycode { Keycode(rawValue: SDLK_PAGEDOWN) }

    static var f1: Keycode { Keycode(rawValue: SDLK_F1) }
    static var f2: Keycode { Keycode(rawValue: SDLK_F2) }
    static var f3: Keycode { Keycode(rawValue: SDLK_F3) }
    static var f4: Keycode { Keycode(rawValue: SDLK_F4) }
    static var f5: Keycode { Keycode(rawValue: SDLK_F5) }
    static var f6: Keycode { Keycode(rawValue: SDLK_F6) }
    static var f7: Keycode { Keycode(rawValue: SDLK_F7) }
    static var f8: Keycode { Keycode(rawValue: SDLK_F8) }
    static var f9: Keycode { Keycode(rawValue: SDLK_F9) }
    static var f10: Keycode { Keycode(rawValue: SDLK_F10) }
    static var f11: Keycode { Keycode(rawValue: SDLK_F11) }
    static var f12: Keycode { Keycode(rawValue: SDLK_F12) }

    /// The character the key types, for keys that type one.
    var character: Character? {
        guard rawValue < 0x4000_0000, rawValue >= 0x20, rawValue != SDLK_DELETE,
              let scalar = Unicode.Scalar(rawValue) else {
            return nil
        }
        return Character(scalar)
    }
}
