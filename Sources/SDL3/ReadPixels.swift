//
//  ReadPixels.swift
//  SDL3
//

import CSDL3

public extension SDLRenderer {

    /// Read pixels back from the current rendering target, as a new surface
    /// in the target's format.
    ///
    /// This is slow: it's for screenshots, not for every frame.
    ///
    /// - Parameter rect: The area to read, in pixels, or `nil` for the whole
    ///   viewport.
    func readPixels(_ rect: SDLRect? = nil) throws(SDLError) -> SDLSurface {
        let surface: UnsafeMutablePointer<SDL_Surface>?
        if let rect {
            var value = rect.internalValue
            surface = SDL_RenderReadPixels(internalPointer, &value)
        } else {
            surface = SDL_RenderReadPixels(internalPointer, nil)
        }
        return SDLSurface(unsafePointer: try surface.sdlThrow(type: "SDLRenderer"))
    }
}

public extension SDLSurface {

    /// A copy of the surface in another pixel format.
    func converted(to format: SDLPixelFormat.Format) throws(SDLError) -> SDLSurface {
        let surface = SDL_ConvertSurface(internalPointer, SDL_PixelFormat(rawValue: format.rawValue))
        return SDLSurface(unsafePointer: try surface.sdlThrow(type: "SDLSurface"))
    }
}
