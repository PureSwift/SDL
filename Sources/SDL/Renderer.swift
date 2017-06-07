//
//  Renderer.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Renderer {
    
    // MARK: - Properties
    
    let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyRenderer(internalPointer)
    }
    
    public init?(window: Window, index: Int, flags: UInt32) {
        
        guard let internalPointer = SDL_CreateRenderer(window.internalPointer, Int32(index), flags)
            else { return nil }
        
        self.internalPointer = internalPointer
    }
}
