//
//  WindowControl.swift
//  SDL3
//

import CSDL3

public extension SDLWindow {

    /// Pixels per window coordinate: 2 on a display with twice the pixels.
    var pixelDensity: Float {
        SDL_GetWindowPixelDensity(internalPointer)
    }

    /// Show the window.
    func show() throws(SDLError) {
        try SDL_ShowWindow(internalPointer).sdlThrow(type: "SDLWindow")
    }

    /// Hide the window.
    func hide() throws(SDLError) {
        try SDL_HideWindow(internalPointer).sdlThrow(type: "SDLWindow")
    }

    /// Minimize the window to an iconic representation.
    func minimize() throws(SDLError) {
        try SDL_MinimizeWindow(internalPointer).sdlThrow(type: "SDLWindow")
    }

    /// Set whether the user can resize the window.
    func setResizable(_ resizable: Bool) throws(SDLError) {
        try SDL_SetWindowResizable(internalPointer, resizable).sdlThrow(type: "SDLWindow")
    }

    /// Move the window, in screen coordinates.
    func setPosition(x: Int32, y: Int32) throws(SDLError) {
        try SDL_SetWindowPosition(internalPointer, x, y).sdlThrow(type: "SDLWindow")
    }

    /// Start accepting Unicode text input events in the window.
    func startTextInput() throws(SDLError) {
        try SDL_StartTextInput(internalPointer).sdlThrow(type: "SDLWindow")
    }

    /// Stop receiving text input events in the window.
    func stopTextInput() throws(SDLError) {
        try SDL_StopTextInput(internalPointer).sdlThrow(type: "SDLWindow")
    }
}
