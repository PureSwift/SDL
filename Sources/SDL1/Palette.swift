//
//  Palette.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Palette
///
/// A non-owning view over the palette of a surface's pixel format. In SDL 1.2 the
/// palette is owned by the surface; use `SDLSurface.setColors(_:firstColor:)` to modify it.
public struct SDLPalette {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<SDL_Palette>

    // MARK: - Initialization

    internal init(_ internalPointer: UnsafeMutablePointer<SDL_Palette>) {
        self.internalPointer = internalPointer
    }

    // MARK: - Accessors

    /// The number of color entries in the palette.
    public var numberOfColors: Int {
        return Int(internalPointer.pointee.ncolors)
    }

    /// The color entries in the palette.
    public var colors: [SDLColor] {
        guard let colors = internalPointer.pointee.colors else { return [] }
        return (0 ..< numberOfColors).map { SDLColor(colors[$0]) }
    }

    /// Access an individual color entry in the palette.
    public subscript (index: Int) -> SDLColor {
        assert(index < numberOfColors, "Invalid index \(index)")
        return SDLColor(internalPointer.pointee.colors[index])
    }
}
