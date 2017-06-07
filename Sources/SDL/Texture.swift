//
//  Texture.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Texture {
    
    // MARK: - Properties
    
    let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyTexture(internalPointer)
    }
    
    public init?(renderer: Renderer, format: PixelFormat.RawValue, access: Access, width: Int, height: Int) {
        
        guard let internalPointer = SDL_CreateTexture(renderer.internalPointer,
                                                      format,
                                                      access.rawValue,
                                                      Int32(width),
                                                      Int32(height))
            else { return nil }
        
        self.internalPointer = internalPointer
    }
}

public extension Texture {
    
    public enum Access: Int32 {
        
        /// Changes rarely, not lockable.
        case `static`
        
        /// Changes frequently, lockable.
        case streaming
        
        /// Texture can be used as a render target
        case target
    }
}
