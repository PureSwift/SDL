//
//  BlendMode.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/8/17.
//

import CSDL2

public extension SDL {
    
    public typealias BlendMode = SDLBlendMode
}

// An enumeration of blend modes used in `Renderer.copy()` and drawing operations.
public enum SDLBlendMode: UInt32, BitMaskOption {
    
    /// Alpha blending
    case alpha = 0x00000001
    
    /// Additive blending
    case additive = 0x00000002
    
    /// Color modulate
    case modulate = 0x00000004
    
    public static let all: Set<SDLBlendMode> = [.alpha, .additive, .modulate]
}

public extension SDLBlendMode {
    
    public init(_ sdl: SDL_BlendMode) {
        
        self.init(rawValue: sdl.rawValue)!
    }
}

public extension SDL_BlendMode {
    
    public init(_ blendMode: SDLBlendMode) {
        
        self.init(rawValue: blendMode.rawValue)
    }
}
