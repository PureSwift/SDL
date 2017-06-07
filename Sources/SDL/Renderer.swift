//
//  Renderer.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Renderer {
    
    // MARK: - Properties
    
    let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyRenderer(internalPointer)
    }
    
    public init?(window: Window, driver: Driver = .default, flags: UInt32) {
        
        guard let internalPointer = SDL_CreateRenderer(window.internalPointer, Int32(driver.index), flags)
            else { return nil }
        
        self.internalPointer = internalPointer
    }
    
    /// The color used for drawing operations (Rect, Line and Clear).
    public var drawColor: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        get {
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0
            var alpha: UInt8 = 0
            
            guard SDL_GetRenderDrawColor(internalPointer, &red, &green, &blue, &alpha) >= 0
                else { return (0,0,0,0) }
            
            return (red, green, blue, alpha)
        }
        
        set {
            
            SDL_SetRenderDrawColor(internalPointer, newValue.red, newValue.green, newValue.blue, newValue.alpha)
        }
    }
    
    // MARK: - Methods
    
    
}

// MARK: - Supporting Types

public extension Renderer {
    
    public struct Info {
        
        
    }
    
    public struct Driver {
        
        public static let `default` = Driver(index: -1)
        
        public let index: Int
    }
}
