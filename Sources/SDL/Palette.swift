//
//  Palette.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Pallette
public final class SDLPalette {
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_Palette>
    
    // MARK: - Initialization
    
    deinit {
        SDL_FreePalette(internalPointer)
    }
    
    /// Create a palette structure with the specified number of color entries.
    public init(numberOfColors: Int) throws {
        
        let internalFormat = SDL_AllocPalette(Int32(numberOfColors))
        self.internalPointer = try internalFormat.sdlThrow(type: type(of: self))
    }
    
    // MARK: - Accessors
    
    /// Number of color entries in palette.
    public var numberOfColors: Int {
        
        return Int(internalPointer.pointee.ncolors)
    }
}
