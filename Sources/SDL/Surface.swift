//
//  Surface.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Surface
public final class SDLSurface {
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_Surface>
    
    // MARK: - Initialization
    
    deinit {
        SDL_FreeSurface(internalPointer)
    }
    
    /// Create an RGB surface.
    public init(rgb mask: (red: UInt, green: UInt, blue: UInt, alpha: UInt),
                size: (width: Int, height: Int),
                depth: Int = 32) throws {
        
        let internalPointer = SDL_CreateRGBSurface(0, CInt(size.width), CInt(size.height), CInt(depth), CUnsignedInt(mask.red), CUnsignedInt(mask.green), CUnsignedInt(mask.blue), CUnsignedInt(mask.alpha))
        
        self.internalPointer = try internalPointer.sdlThrow(type: type(of: self))
    }
    
    // Get the SDL surface associated with the window.
    ///
    /// A new surface will be created with the optimal format for the window,
    /// if necessary. This surface will be freed when the window is destroyed.
    /// - Returns: The window's framebuffer surface, or `nil` on error.
    /// - Note: You may not combine this with 3D or the rendering API on this window.
    public init(window: SDLWindow) throws {
        
        let internalPointer = SDL_GetWindowSurface(window.internalPointer)
        self.internalPointer = try internalPointer.sdlThrow(type: type(of: self))
    }
    
    // MARK: - Accessors
    
    public var width: Int {
        
        return Int(internalPointer.pointee.w)
    }
    
    public var height: Int {
        
        return Int(internalPointer.pointee.h)
    }
    
    public var pitch: Int {
        
        return Int(internalPointer.pointee.pitch)
    }
    
    internal var mustLock: Bool {
        
        // #define SDL_MUSTLOCK(S) (((S)->flags & SDL_RLEACCEL) != 0)
        @inline(__always)
        get { return internalPointer.pointee.flags & UInt32(SDL_RLEACCEL) != 0 }
    }
    
    // MARK: - Methods
    
    /// Get a pointer to the data of the surface, for direct inspection or modification.
    public func withUnsafeMutableBytes<Result>(_ body: (UnsafeMutableRawPointer) throws -> Result) throws -> Result? {
        
        let mustLock = self.mustLock
        
        if mustLock {
            
            try lock()
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
    internal func lock() throws {
        
        try SDL_LockSurface(internalPointer).sdlThrow(type: type(of: self))
    }
    
    internal func unlock() {
        
        SDL_UnlockSurface(internalPointer)
    }
    
    public func blit(to surface: SDLSurface, source: SDL_Rect? = nil, destination: SDL_Rect? = nil) throws {
        
        // TODO rects
        try SDL_UpperBlit(internalPointer, nil, surface.internalPointer, nil).sdlThrow(type: type(of: self))
    }
    
    public func fill(rect: SDL_Rect? = nil, color: SDLColor) throws {
        
        let rectPointer: UnsafePointer<SDL_Rect>?
        if let rect = rect {
            rectPointer = withUnsafePointer(to: rect) { $0 }
        } else {
            rectPointer = nil
        }
        
        try SDL_FillRect(internalPointer, rectPointer, color.rawValue).sdlThrow(type: type(of: self))
    }
}
