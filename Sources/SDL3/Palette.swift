//
//  Palette.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

/// SDL Pallette
public final class SDLPalette {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<SDL_Palette>

    // MARK: - Initialization

    deinit {
        SDL_DestroyPalette(internalPointer)
    }

    /// Create a palette structure with the specified number of color entries.
    public init(numberOfColors: Int) throws(SDLError) {

        let internalFormat = SDL_CreatePalette(Int32(numberOfColors))
        self.internalPointer = try internalFormat.sdlThrow(type: "SDLPalette")
    }

    // MARK: - Accessors

    /// Number of color entries in palette.
    public var numberOfColors: Int {

        return Int(internalPointer.pointee.ncolors)
    }
}
