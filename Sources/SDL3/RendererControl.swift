//
//  RendererControl.swift
//  SDL3
//

import CSDL3

public extension SDLRenderer {

    /// The name of the rendering driver.
    var name: String {
        SDL_GetRendererName(internalPointer).map { String(cString: $0) } ?? ""
    }

    /// The size of the output, in pixels, with any logical size and scale not applied.
    var currentOutputSize: (width: Int, height: Int)? {

        var width: Int32 = 0
        var height: Int32 = 0
        guard SDL_GetCurrentRenderOutputSize(internalPointer, &width, &height) else { return nil }
        return (Int(width), Int(height))
    }

    /// Set the color used for drawing and clearing, with floating point components.
    func setDrawColorFloat(red: Float, green: Float, blue: Float, alpha: Float) throws(SDLError) {
        try SDL_SetRenderDrawColorFloat(internalPointer, red, green, blue, alpha).sdlThrow(type: "SDLRenderer")
    }

    /// Set the scale drawing is multiplied by.
    func setScale(x: Float, y: Float) throws(SDLError) {
        try SDL_SetRenderScale(internalPointer, x, y).sdlThrow(type: "SDLRenderer")
    }

    /// Set the drawing area, or the whole target for `nil`.
    func setViewport(_ rect: SDLRect?) throws(SDLError) {
        try withOptionalUnsafePointer(to: rect?.internalValue) { pointer throws(SDLError) in
            try SDL_SetRenderViewport(internalPointer, pointer).sdlThrow(type: "SDLRenderer")
        }
    }

    /// Set the clip rectangle drawing is limited to, or `nil` to draw anywhere.
    func setClipRect(_ rect: SDLRect?) throws(SDLError) {
        try withOptionalUnsafePointer(to: rect?.internalValue) { pointer throws(SDLError) in
            try SDL_SetRenderClipRect(internalPointer, pointer).sdlThrow(type: "SDLRenderer")
        }
    }

    /// Fill a rectangle with the drawing color.
    func fill(_ rect: SDLFRect) throws(SDLError) {
        var value = rect.internalValue
        try SDL_RenderFillRect(internalPointer, &value).sdlThrow(type: "SDLRenderer")
    }

    /// Copy a whole texture to a rectangle, scaling it.
    func copy(_ texture: SDLTexture, to destination: SDLFRect) throws(SDLError) {
        var value = destination.internalValue
        try SDL_RenderTexture(internalPointer, texture.internalPointer, nil, &value).sdlThrow(type: "SDLRenderer")
    }

    /// Copy a whole texture to a rectangle, rotating it by `angle` degrees about the
    /// rectangle's center and flipping it.
    func copy(_ texture: SDLTexture, to destination: SDLFRect, angle: Double, flip: BitMaskOptionSet<Flip>) throws(SDLError) {
        var value = destination.internalValue
        try SDL_RenderTextureRotated(internalPointer, texture.internalPointer, nil, &value, angle, nil,
                                     SDL_FlipMode(rawValue: flip.rawValue)).sdlThrow(type: "SDLRenderer")
    }

    /// Draw text in SDL's built-in 8x8 font.
    func debugText(_ text: String, x: Float, y: Float) throws(SDLError) {
        try SDL_RenderDebugText(internalPointer, x, y, text).sdlThrow(type: "SDLRenderer")
    }
}

public extension SDLRenderer.Driver {

    /// The rendering driver with a name, such as `opengles2`.
    init?(name: String) {

        for index in 0 ..< Int(SDL_GetNumRenderDrivers()) {
            if let cString = SDL_GetRenderDriver(Int32(index)), String(cString: cString) == name {
                self.init(rawValue: index)
                return
            }
        }
        return nil
    }
}
