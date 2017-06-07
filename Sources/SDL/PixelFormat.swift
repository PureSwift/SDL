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
    
    public init() {
        
        fatalError()
    }
    
    // MARK: - Accessors
    
    /*
    public var palette: Palette {
        
        get { }
        
        set { SDL_SetPixelFormatPalette(<#T##format: UnsafeMutablePointer<SDL_PixelFormat>!##UnsafeMutablePointer<SDL_PixelFormat>!#>, <#T##palette: UnsafeMutablePointer<SDL_Palette>!##UnsafeMutablePointer<SDL_Palette>!#>) }
    }*/
}

