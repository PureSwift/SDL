//
//  PixelFormat.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class PixelFormat {
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_PixelFormat>
    
    // MARK: - Initialization
    
    deinit {
        
        SDL_FreeFormat(internalPointer)
    }
    
    public init?(rawValue: UInt32) {
        
        guard let internalFormat = SDL_AllocFormat(rawValue)
            else { return nil }
        
        self.internalPointer = internalFormat
    }
    
    // MARK: - Methods
    
    @inline(__always)
    public static func name(for rawValue: UInt32) -> String? {
        
        guard let cString = SDL_GetPixelFormatName(rawValue)
            else { return nil }
        
        return String(cString: cString)
    }
    
    /// Set the palette for a pixel format structure
    public func setPalette(_ palette: Palette) -> Bool {
        
        SDL_SetPixelFormatPalette(internalPointer, palette.internalPointer)
    }
}
