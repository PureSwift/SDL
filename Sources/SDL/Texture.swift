//
//  Texture.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Texture {
    
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
    public init?(renderer: Renderer, format: PixelFormat.RawValue, access: Access, width: Int, height: Int) {
        
        guard let internalPointer = SDL_CreateTexture(renderer.internalPointer,
                                                      format,
                                                      access.rawValue,
                                                      Int32(width),
                                                      Int32(height))
            else { return nil }
        
        self.internalPointer = internalPointer
    }
    
    /// Create a texture from an existing surface.
    /// - Parameter renderer: The renderer.
    /// - Parameter surface: The surface containing pixel data used to fill the texture.
    /// - Returns: The created texture is returned, or `nil` on error.
    public init?(renderer: Renderer, surface: Surface) {
        
        guard let internalPointer = SDL_CreateTextureFromSurface(renderer.internalPointer, surface.internalPointer)
            else { return nil }
        
        self.internalPointer = internalPointer
    }
    
    // MARK: - Accessors
    
    public var format: PixelFormat.RawValue {
        
        var value = UInt32()
        
        guard SDL_QueryTexture(internalPointer, &value, nil, nil, nil) >= 0
            else { return 0 }
        
        return value
    }
    
    public var access: Access {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, &value, nil, nil) >= 0
            else { return .static }
        
        return Access(rawValue: value)!
    }
    
    public var width: Int {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, nil, &value, nil) >= 0
            else { return 0 }
        
        return Int(value)
    }
    
    public var height: Int {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, nil, nil, &value) >= 0
            else { return 0 }
        
        return Int(value)
    }
    
    /// The blend mode used for texture copy operations.
    public var blendMode: BlendMode {
        
        get {
            
            var value = SDL_BlendMode(.none)
            
            SDL_GetTextureBlendMode(internalPointer, &value)
            
            return BlendMode(value)
        }
        
        set { SDL_SetTextureBlendMode(internalPointer, SDL_BlendMode(newValue)) }
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
    public func withUnsafeMutableBytes<Result>(for rect: SDL_Rect? = nil, _ body: (_ pointer: UnsafeMutableRawPointer, _ pitch: Int) throws -> Result) rethrows -> Result? {
        
        let rectPointer: UnsafeMutablePointer<SDL_Rect>?
        
        if var rect = rect {
            
            rectPointer = UnsafeMutablePointer.allocate(capacity: 1)
            
            rectPointer?.pointee = rect
            
            defer { rectPointer?.deallocate(capacity: 1) }
            
        } else {
            
            rectPointer = nil
        }
        
        var pitch: Int32 = 0
        
        var pixels: UnsafeMutableRawPointer? = nil
        
        guard SDL_LockTexture(internalPointer, rectPointer, &pixels, &pitch) >= 0
            else { return nil }
        
        defer { SDL_UnlockTexture(internalPointer) }
        
        guard let pointer = pixels
            else { return nil }
        
        let result = try body(pointer, Int(pitch))
        
        return result
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
