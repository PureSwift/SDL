//
//  Error.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL2

/// SDL Error
public struct SDLError: CustomStringConvertible, Error {
    
    public let description: String
}

internal extension SDLError {
    
    /// Text for last reported error.
    static var current: SDLError? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        SDL_ClearError() // reset error
        let errorDescription = String(cString: cString)
        return SDLError(description: errorDescription)
    }
}

internal extension CInt {
    
    /// Throws for error codes.
    @inline(__always)
    func sdlThrow() throws {
        
        guard self >= 0 else {
            guard let error = SDLError.current else {
                assertionFailure("No error for error code \(self)")
                return
            }
            throw error
        }
    }
}

internal extension Optional {
    
    /// Unwraps optional value, throwing error if nil.
    @inline(__always)
    func sdlThrow() throws -> Wrapped {
        
        guard let value = self else {
            guard let error = SDLError.current else {
                assertionFailure("No error for nil value \(Wrapped.self)")
                throw SDLError(description: "")
            }
            throw error
        }
        return value
    }
}
