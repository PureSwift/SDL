//
//  Palette.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Palette {
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_Palette>
    
    // MARK: - Initialization
    
    deinit {
        SDL_FreePalette(internalPointer)
    }
    
    public init?(numberOfColors: Int) {
        
        guard let internalFormat = SDL_AllocPalette(Int32(numberOfColors))
            else { return nil }
        
        self.internalPointer = internalFormat
    }
}
