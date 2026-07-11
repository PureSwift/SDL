//
//  PixelFormat.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Pixel Format
///
/// In SDL 1.2 a pixel format is owned by the surface it describes; this type is a
/// non-owning view over an existing `SDL_PixelFormat` and must not outlive its surface.
public struct SDLPixelFormat {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<SDL_PixelFormat>

    // MARK: - Initialization

    internal init(_ internalPointer: UnsafeMutablePointer<SDL_PixelFormat>) {
        self.internalPointer = internalPointer
    }

    // MARK: - Accessors

    /// The number of bits used to represent each pixel.
    public var bitsPerPixel: UInt8 {
        return internalPointer.pointee.BitsPerPixel
    }

    /// The number of bytes used to represent each pixel.
    public var bytesPerPixel: UInt8 {
        return internalPointer.pointee.BytesPerPixel
    }

    /// The bit masks used to extract each color component.
    public var mask: (red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32) {
        let format = internalPointer.pointee
        return (format.Rmask, format.Gmask, format.Bmask, format.Amask)
    }

    /// The pixel value that is treated as transparent.
    public var colorKey: UInt32 {
        return internalPointer.pointee.colorkey
    }

    /// The overall surface alpha value.
    public var alpha: UInt8 {
        return internalPointer.pointee.alpha
    }

    // MARK: - Methods

    /// Map an RGB color to a pixel value for this format.
    public func map(red: UInt8, green: UInt8, blue: UInt8) -> UInt32 {
        return SDL_MapRGB(internalPointer, red, green, blue)
    }

    /// Map an RGBA color to a pixel value for this format.
    public func map(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return SDL_MapRGBA(internalPointer, red, green, blue, alpha)
    }

    /// Get the RGB components of a pixel value for this format.
    public func components(of pixel: UInt32) -> (red: UInt8, green: UInt8, blue: UInt8) {
        var components: (red: UInt8, green: UInt8, blue: UInt8) = (0, 0, 0)
        SDL_GetRGB(pixel, internalPointer, &components.red, &components.green, &components.blue)
        return components
    }

    /// Get the RGBA components of a pixel value for this format.
    public func componentsWithAlpha(of pixel: UInt32) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        var components: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) = (0, 0, 0, 0)
        SDL_GetRGBA(pixel, internalPointer, &components.red, &components.green, &components.blue, &components.alpha)
        return components
    }
}
