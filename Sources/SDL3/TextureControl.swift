//
//  TextureControl.swift
//  SDL3
//

import CSDL3

public extension SDLTexture {

    /// Set the color multiplied into copy operations, with floating point components.
    func setColorModulation(red: Float, green: Float, blue: Float) throws(SDLError) {
        try SDL_SetTextureColorModFloat(internalPointer, red, green, blue).sdlThrow(type: "SDLTexture")
    }

    /// Set the alpha multiplied into copy operations, as a fraction.
    func setAlphaModulation(_ alpha: Float) throws(SDLError) {
        try SDL_SetTextureAlphaModFloat(internalPointer, alpha).sdlThrow(type: "SDLTexture")
    }

    /// Replace the pixels in a texture, or a rectangle of it.
    func update(_ rect: SDLRect? = nil, pixels: UnsafeRawPointer, pitch: Int) throws(SDLError) {
        try withOptionalUnsafePointer(to: rect?.internalValue) { pointer throws(SDLError) in
            try SDL_UpdateTexture(internalPointer, pointer, pixels, Int32(pitch)).sdlThrow(type: "SDLTexture")
        }
    }
}
