//
//  Error.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL2

/// SDL Error
public struct SDLError: CustomStringConvertible, Swift.Error {
    
    public let description: String
}

internal extension SDLError {
    
    /// Text for last reported error.
    static var errorDescription: String? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        return String(cString: cString)
    }
}

internal extension CInt {
    
    /// Throws for negative error codes
    @inline(__always)
    func sdlThrow() throws {
        
        guard self >= 0
            else { throw SDLError(description: SDLError.errorDescription ?? "") }
    }
}

internal extension Optional {
    
    /// Unwraps optional value, throwing error if nil.
    @inline(__always)
    func sdlThrow() throws -> Wrapped {
        
        guard let value = self
            else { throw SDLError(description: SDLError.errorDescription ?? "") }
        
        return value
    }
}
