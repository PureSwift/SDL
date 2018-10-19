//
//  Texture.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public extension SDL {
    
    /// SDL Texture
    public typealias Texture = SDLTexture
}

/// SDL Texture
public final class SDLTexture {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyTexture(internalPointer)
    }
    
    /// Create a texture for a rendering context.
    ///
    /// - Parameter renderer The renderer.
    /// - Parameter format: The format of the texture.
    /// - Parameter access: One of the enumerated values in `Texture.Access`.
    /// - Parameter width: The width of the texture in pixels.
    /// - Parameter height: The height of the texture in pixels.
    /// - Returns: The created texture is returned, or `nil` if no rendering context
    /// was active, the format was unsupported, or the width or height were out of range.
    public init(renderer: Renderer, format: SDL.PixelFormat.Format, access: Access, width: Int, height: Int) throws {
        
        let internalPointer = SDL_CreateTexture(renderer.internalPointer,
                                                      format.rawValue,
                                                      access.rawValue,
                                                      Int32(width),
                                                      Int32(height))
        
        self.internalPointer = try internalPointer.sdlThrow()
    }
    
    /// Create a texture from an existing surface.
    /// - Parameter renderer: The renderer.
    /// - Parameter surface: The surface containing pixel data used to fill the texture.
    /// - Returns: The created texture is returned, or `nil` on error.
    public init(renderer: Renderer, surface: Surface) throws {
        
        let internalPointer = SDL_CreateTextureFromSurface(renderer.internalPointer, surface.internalPointer)
        self.internalPointer = try internalPointer.sdlThrow()
    }
    
    // MARK: - Accessors
    
    public func attributes() throws -> Attributes {
        
        var format = UInt32()
        var access = Int32()
        var width = Int32()
        var height = Int32()
        
        try SDL_QueryTexture(internalPointer, &format, &access, &width, &height).sdlThrow()
        
        return Attributes(format: SDL.PixelFormat.Format(rawValue: format),
                          access: SDL.Texture.Access(rawValue: access)!,
                          width: Int(width),
                          height: Int(height))
    }
    
    /// The blend mode used for texture copy operations.
    public func blendMode() throws -> SDL.BlendMode {
        
        var value = SDL_BlendMode(0)
        try SDL_GetTextureBlendMode(internalPointer, &value).sdlThrow()
        return SDL.BlendMode(value)
    }
    
    public func setBlendMode(_ newValue: SDL.BlendMode) throws {
        
        try SDL_SetTextureBlendMode(internalPointer, SDL_BlendMode(newValue)).sdlThrow()
    }
    
    // MARK: - Methods
    
    /// Lock a portion of the texture for write-only pixel access (only valid for streaming textures).
    /// - Parameters:
    ///     - rect: A pointer to the rectangle to lock for access.
    ///             If the rect is `nil`, the entire texture will be locked.
    ///             appropriately offset by the locked area.
    ///     - body: The closure is called with the pixel pointer and pitch.
    ///     - pointer: The pixel pointer.
    ///     - pitch: The pitch.
    public func withUnsafeMutableBytes<Result>(for rect: SDL_Rect? = nil, _ body: (_ pointer: UnsafeMutableRawPointer, _ pitch: Int) throws -> Result) throws -> Result? {
        
        let rectPointer: UnsafeMutablePointer<SDL_Rect>?
        
        if var rect = rect {
            
            rectPointer = UnsafeMutablePointer.allocate(capacity: 1)
            
            rectPointer?.pointee = rect
            
            defer { rectPointer?.deallocate() }
            
        } else {
            
            rectPointer = nil
        }
        
        var pitch: Int32 = 0
        
        var pixels: UnsafeMutableRawPointer? = nil
        
        try SDL_LockTexture(internalPointer, rectPointer, &pixels, &pitch).sdlThrow()
        
        defer { SDL_UnlockTexture(internalPointer) }
        
        guard let pointer = pixels
            else { return nil }
        
        let result = try body(pointer, Int(pitch))
        
        return result
    }
}

public extension SDLTexture {
    
    public enum Access: Int32 {
        
        /// Changes rarely, not lockable.
        case `static`
        
        /// Changes frequently, lockable.
        case streaming
        
        /// Texture can be used as a render target
        case target
    }
}

public extension SDLTexture {
    
    /// SDL Texture Attributes
    public struct Attributes {
        
        public let format: SDL.PixelFormat.Format
        
        public let access: SDL.Texture.Access
        
        public let width: Int
        
        public let height: Int
    }
}
