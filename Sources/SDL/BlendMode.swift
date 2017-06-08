//
//  BlendMode.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/8/17.
//

import struct CSDL2.SDL_BlendMode

// An enumeration of blend modes used in `Renderer.copy()` and drawing operations.
public enum BlendMode: UInt32 {
    
    /// No blending
    case none = 0x00000000
    
    /// Alpha blending
    case alpha = 0x00000001
    
    /// Additive blending
    case additive = 0x00000002
    
    /// Color modulate
    case modulate = 0x00000004
}

public extension BlendMode {
    
    public init(_ sdl: SDL_BlendMode) {
        
        self.init(rawValue: sdl.rawValue)!
    }
}

public extension SDL_BlendMode {
    
    public init(_ blendMode: BlendMode) {
        
        self.init(rawValue: blendMode.rawValue)
    }
}
