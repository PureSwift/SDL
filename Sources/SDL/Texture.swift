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
    
    public init?(renderer: Renderer, format: UInt32, access: Int, width: Int, height: Int) {
        
        guard let internalPointer = SDL_CreateTexture(internalPointer, <#T##format: Uint32##Uint32#>, <#T##access: Int32##Int32#>, <#T##w: Int32##Int32#>, <#T##h: Int32##Int32#>) else { return nil }
        
        self.internalPointer = internalPointer
    }
}
