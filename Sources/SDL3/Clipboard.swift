//
//  Clipboard.swift
//  SDL3
//

import CSDL3

public extension SDL {

    /// Whether the clipboard holds text that isn't empty.
    static var hasClipboardText: Bool {
        SDL_HasClipboardText()
    }

    /// The clipboard's text, empty if it holds none.
    static var clipboardText: String {

        get {
            guard let pointer = SDL_GetClipboardText() else { return "" }
            defer { SDL_free(pointer) }
            return String(cString: pointer)
        }
        set { SDL_SetClipboardText(newValue) }
    }
}
