//
//  PixelFormat.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class PixelFormat: RawRepresentable {
    
    public typealias RawValue = UInt32
    
    // MARK: - Properties
    
    internal let internalPointer: UnsafeMutablePointer<SDL_PixelFormat>
    
    // MARK: - Initialization
    
    deinit {
        
        SDL_FreeFormat(internalPointer)
    }
    
    public init?(rawValue: RawValue) {
        
        guard let internalFormat = SDL_AllocFormat(rawValue)
            else { return nil }
        
        self.internalPointer = internalFormat
    }
    
    // MARK: - Accessors
    
    public var rawValue: RawValue {
        
        return internalPointer.pointee.format
    }
    
    public var name: String {
        
        return PixelFormat.name(for: self.internalPointer.pointee.format) ?? ""
    }
    
    // MARK: - Class Methods
    
    @inline(__always)
    public static func name(for rawValue: UInt32) -> String? {
        
        guard let cString = SDL_GetPixelFormatName(rawValue)
            else { return nil }
        
        return String(cString: cString)
    }
    
    // MARK: - Methods
    
    /// Set the palette for a pixel format structure
    public func setPalette(_ palette: Palette) -> Bool {
        
        return SDL_SetPixelFormatPalette(internalPointer, palette.internalPointer) >= 0
    }
}
