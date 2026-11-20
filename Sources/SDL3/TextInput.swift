//
//  TextInput.swift
//  SDL3
//

import CSDL3

public extension SDLWindow {

    /// Whether the window is taking text input, through an input method
    /// where there is one.
    var isTextInputActive: Bool {
        SDL_TextInputActive(internalPointer)
    }

    /// Says where text is being typed, in window coordinates, so an input
    /// method can place its candidates beside it.
    ///
    /// - Parameter rect: The area of the text, or `nil` to clear it.
    /// - Parameter cursor: The cursor's offset from the area's leading edge.
    func setTextInputArea(_ rect: SDLRect?, cursor: Int = 0) throws(SDLError) {
        if let rect {
            var value = rect.internalValue
            try SDL_SetTextInputArea(internalPointer, &value, Int32(cursor)).sdlThrow(type: "SDLWindow")
        } else {
            try SDL_SetTextInputArea(internalPointer, nil, Int32(cursor)).sdlThrow(type: "SDLWindow")
        }
    }
}
