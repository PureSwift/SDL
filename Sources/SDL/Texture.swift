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
        
        guard SDL_QueryTexture(internalPointer, &value, nil, nil, nil) > 0
            else { return 0 }
        
        return value
    }
    
    public var access: Access {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, &value, nil, nil) > 0
            else { return .static }
        
        return Access(rawValue: value)!
    }
    
    public var width: Int {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, nil, &value, nil) > 0
            else { return 0 }
        
        return Int(value)
    }
    
    public var height: Int {
        
        var value = Int32()
        
        guard SDL_QueryTexture(internalPointer, nil, nil, nil, &value) > 0
            else { return 0 }
        
        return Int(value)
    }
    
    // MARK: - Methods
    
    /// Get a pointer to the data of the surface, for direct inspection or modification.
    public func withUnsafeMutableBytes<Result>(_ body: (UnsafeMutableRawPointer) throws -> Result) rethrows -> Result? {
        
        let mustLock = self.access.lockable
        
        if mustLock {
            
            guard lock() else { return nil }
        }
        
        let result = try body(internalPointer.pointee.pixels)
        
        if mustLock {
            
            unlock()
        }
        
        return result
    }
    
    /// Sets up a surface for directly accessing the pixels.
    ///
    /// Between calls to `lock()` / `unlock()`, you can write to and read from `surface->pixels`,
    /// using the pixel format stored in `surface->format`.
    /// Once you are done accessing the surface, you should use `unlock()` to release it.
    /// Not all surfaces require locking.
    /// If `Surface.mustLock` is `false`, then you can read and write to the surface at any time,
    /// and the pixel format of the surface will not change.
    ///
    /// - Note: No operating system or library calls should be made between lock/unlock pairs,
    /// as critical system locks may be held during this time.
    internal func lock() -> Bool {
        
        return SDL_LockTexture(<#T##texture: OpaquePointer!##OpaquePointer!#>, <#T##rect: UnsafePointer<SDL_Rect>!##UnsafePointer<SDL_Rect>!#>, <#T##pixels: UnsafeMutablePointer<UnsafeMutableRawPointer?>!##UnsafeMutablePointer<UnsafeMutableRawPointer?>!#>, <#T##pitch: UnsafeMutablePointer<Int32>!##UnsafeMutablePointer<Int32>!#>)(internalPointer) > 0
    }
    
    internal func unlock() {
        
        SDL_UnlockSurface(internalPointer)
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
        
        public var lockable: Bool {
            
            switch self {
            case .static: return false
            case .streaming: return true
            case .target: return false // Valid?
            }
        }
    }
}
