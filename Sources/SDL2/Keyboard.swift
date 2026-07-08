//
//  Keyboard.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL2

public extension SDL {

    /// A snapshot of the current state of the keyboard, indexed by `Scancode.rawValue`.
    static var keyboardState: [Bool] {

        var count: Int32 = 0
        guard let pointer = SDL_GetKeyboardState(&count) else { return [] }
        return (0 ..< Int(count)).map { pointer[$0] != 0 }
    }
}

public extension Scancode {

    /// Get a human-readable name for the scancode.
    ///
    /// - Returns: `nil` if the scancode doesn't have a name.
    var name: String? {

        let name = String(cString: SDL_GetScancodeName(SDL_Scancode(rawValue: rawValue)))
        return name.isEmpty ? nil : name
    }
}

// MARK: - Named Scancodes

public extension Scancode {

    static var a: Scancode { Scancode(rawValue: SDL_SCANCODE_A.rawValue) }
    static var b: Scancode { Scancode(rawValue: SDL_SCANCODE_B.rawValue) }
    static var c: Scancode { Scancode(rawValue: SDL_SCANCODE_C.rawValue) }
    static var d: Scancode { Scancode(rawValue: SDL_SCANCODE_D.rawValue) }
    static var e: Scancode { Scancode(rawValue: SDL_SCANCODE_E.rawValue) }
    static var f: Scancode { Scancode(rawValue: SDL_SCANCODE_F.rawValue) }
    static var g: Scancode { Scancode(rawValue: SDL_SCANCODE_G.rawValue) }
    static var h: Scancode { Scancode(rawValue: SDL_SCANCODE_H.rawValue) }
    static var i: Scancode { Scancode(rawValue: SDL_SCANCODE_I.rawValue) }
    static var j: Scancode { Scancode(rawValue: SDL_SCANCODE_J.rawValue) }
    static var k: Scancode { Scancode(rawValue: SDL_SCANCODE_K.rawValue) }
    static var l: Scancode { Scancode(rawValue: SDL_SCANCODE_L.rawValue) }
    static var m: Scancode { Scancode(rawValue: SDL_SCANCODE_M.rawValue) }
    static var n: Scancode { Scancode(rawValue: SDL_SCANCODE_N.rawValue) }
    static var o: Scancode { Scancode(rawValue: SDL_SCANCODE_O.rawValue) }
    static var p: Scancode { Scancode(rawValue: SDL_SCANCODE_P.rawValue) }
    static var q: Scancode { Scancode(rawValue: SDL_SCANCODE_Q.rawValue) }
    static var r: Scancode { Scancode(rawValue: SDL_SCANCODE_R.rawValue) }
    static var s: Scancode { Scancode(rawValue: SDL_SCANCODE_S.rawValue) }
    static var t: Scancode { Scancode(rawValue: SDL_SCANCODE_T.rawValue) }
    static var u: Scancode { Scancode(rawValue: SDL_SCANCODE_U.rawValue) }
    static var v: Scancode { Scancode(rawValue: SDL_SCANCODE_V.rawValue) }
    static var w: Scancode { Scancode(rawValue: SDL_SCANCODE_W.rawValue) }
    static var x: Scancode { Scancode(rawValue: SDL_SCANCODE_X.rawValue) }
    static var y: Scancode { Scancode(rawValue: SDL_SCANCODE_Y.rawValue) }
    static var z: Scancode { Scancode(rawValue: SDL_SCANCODE_Z.rawValue) }

    static var escape: Scancode { Scancode(rawValue: SDL_SCANCODE_ESCAPE.rawValue) }
    static var `return`: Scancode { Scancode(rawValue: SDL_SCANCODE_RETURN.rawValue) }
    static var space: Scancode { Scancode(rawValue: SDL_SCANCODE_SPACE.rawValue) }
    static var tab: Scancode { Scancode(rawValue: SDL_SCANCODE_TAB.rawValue) }

    static var up: Scancode { Scancode(rawValue: SDL_SCANCODE_UP.rawValue) }
    static var down: Scancode { Scancode(rawValue: SDL_SCANCODE_DOWN.rawValue) }
    static var left: Scancode { Scancode(rawValue: SDL_SCANCODE_LEFT.rawValue) }
    static var right: Scancode { Scancode(rawValue: SDL_SCANCODE_RIGHT.rawValue) }

    static var f8: Scancode { Scancode(rawValue: SDL_SCANCODE_F8.rawValue) }
    static var f9: Scancode { Scancode(rawValue: SDL_SCANCODE_F9.rawValue) }
    static var f10: Scancode { Scancode(rawValue: SDL_SCANCODE_F10.rawValue) }

    static var minus: Scancode { Scancode(rawValue: SDL_SCANCODE_MINUS.rawValue) }
    static var equals: Scancode { Scancode(rawValue: SDL_SCANCODE_EQUALS.rawValue) }
    static var leftBracket: Scancode { Scancode(rawValue: SDL_SCANCODE_LEFTBRACKET.rawValue) }
    static var rightBracket: Scancode { Scancode(rawValue: SDL_SCANCODE_RIGHTBRACKET.rawValue) }
    static var backslash: Scancode { Scancode(rawValue: SDL_SCANCODE_BACKSLASH.rawValue) }
    static var semicolon: Scancode { Scancode(rawValue: SDL_SCANCODE_SEMICOLON.rawValue) }
    static var apostrophe: Scancode { Scancode(rawValue: SDL_SCANCODE_APOSTROPHE.rawValue) }
    static var grave: Scancode { Scancode(rawValue: SDL_SCANCODE_GRAVE.rawValue) }

    static var keypadDivide: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_DIVIDE.rawValue) }
    static var keypadMultiply: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_MULTIPLY.rawValue) }
    static var keypadMinus: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_MINUS.rawValue) }
    static var keypadPlus: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_PLUS.rawValue) }
    static var keypadEnter: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_ENTER.rawValue) }
    static var keypadPeriod: Scancode { Scancode(rawValue: SDL_SCANCODE_KP_PERIOD.rawValue) }

    static var leftAlt: Scancode { Scancode(rawValue: SDL_SCANCODE_LALT.rawValue) }
    static var rightAlt: Scancode { Scancode(rawValue: SDL_SCANCODE_RALT.rawValue) }
    static var leftGUI: Scancode { Scancode(rawValue: SDL_SCANCODE_LGUI.rawValue) }
    static var rightGUI: Scancode { Scancode(rawValue: SDL_SCANCODE_RGUI.rawValue) }
    static var leftControl: Scancode { Scancode(rawValue: SDL_SCANCODE_LCTRL.rawValue) }
    static var rightControl: Scancode { Scancode(rawValue: SDL_SCANCODE_RCTRL.rawValue) }
    static var leftShift: Scancode { Scancode(rawValue: SDL_SCANCODE_LSHIFT.rawValue) }
    static var rightShift: Scancode { Scancode(rawValue: SDL_SCANCODE_RSHIFT.rawValue) }
}
