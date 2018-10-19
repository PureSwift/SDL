//
//  PixelFormat.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Pixel Format
public final class SDLPixelFormat {
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_PixelFormat>
    
    // MARK: - Initialization
    
    deinit {
        
        SDL_FreeFormat(internalPointer)
    }
    
    /// Creates a new Pixel Format.
    ///
    /// -Note: Returned structure may come from a shared global cache (i.e. not newly allocated), and hence should not be modified, especially the palette. Weird errors such as `Blit combination not supported` may occur.
    public init(format: SDLPixelFormat.Format) throws {
        
        let internalFormat = SDL_AllocFormat(format.rawValue)
        self.internalPointer = try internalFormat.sdlThrow()
    }
    
    // MARK: - Accessors
    
    /// Pixel format
    public var format: SDLPixelFormat.Format {
        
        return Format(rawValue: internalPointer.pointee.format)
    }
    
    // MARK: - Methods
    
    /// Set the palette for a pixel format structure
    public func setPalette(_ palette: SDLPalette) throws {
        
        try SDL_SetPixelFormatPalette(internalPointer, palette.internalPointer).sdlThrow()
    }
}

// MARK: - Supporting Types

public extension SDLPixelFormat {
    
    /// SDL Pixel Format Enum
    public struct Format: RawRepresentable {
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            
            self.rawValue = rawValue
        }
    }
}

extension SDLPixelFormat.Format: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        
        self.init(rawValue: value)
    }
}

extension SDLPixelFormat.Format: CustomStringConvertible {
    
    /// Get the human readable name of a pixel format.
    public var description: String {
        
        return String(cString: SDL_GetPixelFormatName(rawValue))
    }
}
