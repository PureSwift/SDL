//
//  Renderer.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Renderer
public final class SDLRenderer {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyRenderer(internalPointer)
    }
    
    /// Create a 2D rendering context for a window.
    public init(window: SDLWindow,
                driver: SDLRenderer.Driver = .default,
                options: BitMaskOptionSet<SDLRenderer.Option> = []) throws {
        
        let internalPointer = SDL_CreateRenderer(window.internalPointer, Int32(driver.rawValue), options.rawValue)
        self.internalPointer = try internalPointer.sdlThrow()
    }
    
    /// The color used for drawing operations (Rect, Line and Clear).
    public func drawColor() throws -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        var red: UInt8 = 0
        var green: UInt8 = 0
        var blue: UInt8 = 0
        var alpha: UInt8 = 0
        
        try SDL_GetRenderDrawColor(internalPointer, &red, &green, &blue, &alpha).sdlThrow()
        
        return (red, green, blue, alpha)
    }
    
    public func setDrawColor(_ newValue: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)) throws {
        
         try SDL_SetRenderDrawColor(internalPointer, newValue.red, newValue.green, newValue.blue, newValue.alpha).sdlThrow()
    }
    
    /// Current rendering target texture.
    public private(set) var target: SDLTexture?
    
    public func setTarget(_ newValue: SDLTexture?) throws {
        
        try SDL_SetRenderTarget(internalPointer, target?.internalPointer).sdlThrow()
        
        // hold reference
        self.target = newValue
    }
    
    /// The blend mode used for drawing operations (Fill and Line).
    public func drawBlendMode() throws -> BitMaskOptionSet<SDLBlendMode> {
        
        var value = SDL_BlendMode(0)
        SDL_GetRenderDrawBlendMode(internalPointer, &value)
        return BitMaskOptionSet<SDLBlendMode>(rawValue: value.rawValue)
    }
    
    /// Set the blend mode used for drawing operations (Fill and Line).
    ///
    /// - Note: If the blend mode is not supported, the closest supported mode is chosen.
    public func setDrawBlendMode(_ newValue: BitMaskOptionSet<SDLBlendMode>) throws {
        
        try SDL_SetRenderDrawBlendMode(internalPointer, SDL_BlendMode(newValue.rawValue)).sdlThrow()
    }
    
    // MARK: - Methods
    
    /// Clear the current rendering target with the drawing color
    /// This function clears the entire rendering target, ignoring the viewport.
    public func clear() throws {
        
        try SDL_RenderClear(internalPointer).sdlThrow()
    }
    
    /// Update the screen with rendering performed.
    public func present() {
        
        SDL_RenderPresent(internalPointer)
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source: SDL_Rect? = nil, destination: SDL_Rect? = nil) throws {
        
        let sourcePointer: UnsafeMutablePointer<SDL_Rect>?
        
        defer { sourcePointer?.deallocate() }
        
        if let rect = source {
            
            sourcePointer = UnsafeMutablePointer.allocate(capacity: 1)
            
            sourcePointer?.pointee = rect
            
        } else {
            
            sourcePointer = nil
        }
        
        let destinationPointer: UnsafeMutablePointer<SDL_Rect>?
        
        defer { destinationPointer?.deallocate() }
        
        if let rect = destination {
            
            destinationPointer = UnsafeMutablePointer.allocate(capacity: 1)
            
            destinationPointer?.pointee = rect
            
        } else {
            
            destinationPointer = nil
        }
        
        try SDL_RenderCopy(internalPointer, texture.internalPointer, sourcePointer, destinationPointer).sdlThrow()
    }
}

// MARK: - Supporting Types

public extension SDLRenderer {
    
    /// An enumeration of flags used when creating a rendering context.
    public enum Option: UInt32, BitMaskOption {
        
        /// The renderer is a software fallback.
        case software = 0x00000001
        
        /// The renderer uses hardware acceleration.
        case accelerated = 0x00000002
        
        /// Present is synchronized with the refresh rate
        case presentVsync = 0x00000004
        
        /// The renderer supports rendering to texture
        case targetTexture = 0x00000008
        
        public static let all: Set<SDLRenderer.Option> = [.software, .accelerated, .presentVsync, .targetTexture]
    }
    
}

public extension SDLRenderer {
    
    /// Information on the capabilities of a render driver or context.
    public struct Info {
        
        /// The name of the renderer.
        public let name: String
        
        /// Supported options.
        public let options: BitMaskOptionSet<SDLRenderer.Option>
        
        /// The number of available texture formats.
        public let formats: [SDLPixelFormat.Format]
        
        /// The maximimum texture size.
        public let maximumSize: (width: Int, height: Int)
        
        public init(driver: Driver) throws {
            
            // get driver info from SDL
            var info = SDL_RendererInfo()
            try SDL_GetRenderDriverInfo(Int32(driver.rawValue), &info).sdlThrow()
            
            self.init(info)
        }
        
        internal init(_ info: SDL_RendererInfo) {
            
            self.name = String(cString: info.name)
            self.options = BitMaskOptionSet<SDLRenderer.Option>(rawValue: info.flags)
            self.maximumSize = (Int(info.max_texture_width), Int(info.max_texture_height))
            
            // copy formats array
            let formatsCount = Int(info.num_texture_formats)
            let formats = [info.texture_formats.0,
                           info.texture_formats.1,
                           info.texture_formats.2,
                           info.texture_formats.3,
                           info.texture_formats.4,
                           info.texture_formats.5,
                           info.texture_formats.6,
                           info.texture_formats.7,
                           info.texture_formats.8,
                           info.texture_formats.9,
                           info.texture_formats.10,
                           info.texture_formats.11,
                           info.texture_formats.12,
                           info.texture_formats.13,
                           info.texture_formats.14,
                           info.texture_formats.15]
            
            self.formats = formats.prefix(formatsCount).map { SDLPixelFormat.Format(rawValue: $0) }
        }
    }
}

public extension SDLRenderer {
    
    public struct Driver: IndexRepresentable {
        
        public static var all: CountableSet<Driver> {
            
            let count = Int(SDL_GetNumRenderDrivers())
            return CountableSet<Driver>(count: count)
        }
        
        public static let `default` = Driver(rawValue: -1)
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            
            self.rawValue = rawValue
        }
    }
}
