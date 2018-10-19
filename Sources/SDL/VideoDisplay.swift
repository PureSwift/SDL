//
//  VideoDisplay.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL2

/// SDL Video Display
public struct SDLVideoDisplay: IndexRepresentable {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
}

extension SDLVideoDisplay: CustomStringConvertible {
    
    public var description: String {
        
        return "SDL Display \(rawValue)"
    }
}

public extension SDLVideoDisplay {
    
    static var all: CountableSet<SDLVideoDisplay> {
        
        let count = Int(SDL_GetNumVideoDisplays())
        
        return CountableSet<SDLVideoDisplay>(count: count)
    }
}
