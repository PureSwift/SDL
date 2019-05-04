//
//  Error.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL2

/// SDL Error
public struct SDLError: Error {
    
    public let errorMessage: String
    
    internal let debugInformation: DebugInformation?
}

extension SDLError: CustomStringConvertible {
    
    public var description: String {
        
        return errorMessage
    }
}

extension SDLError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var description = errorMessage
        if let debugInformation = debugInformation {
            description += " " + "(\(debugInformation.description))"
        }
        return description
    }
}

internal extension SDLError {
    
    final class DebugInformation: CustomStringConvertible {
        
        public let file: String
        
        public let type: String
        
        public let function: String
        
        public let line: UInt
        
        internal init(file: String,
                      type: Any,
                      function: String,
                      line: UInt) {
            
            self.file = file
            self.function = function
            self.line = line
            self.type = String(reflecting: type)
        }
        
        public var description: String {
            let fileName = file.split(separator: "/").last.flatMap { String($0) } ?? file
            return "\(fileName):\(line.description) \(type).\(function)"
        }
    }
}

internal extension SDLError {
    
    /// Text for last reported error.
    static func current(debugInformation: DebugInformation? = nil) -> SDLError? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        SDL_ClearError() // reset error
        let errorDescription = String(cString: cString)
        
        return SDLError(errorMessage: errorDescription, debugInformation: debugInformation)
    }
}

internal extension CInt {
    
    /// Throws for error codes.
    @inline(__always)
    func sdlThrow(file: String = #file,
                  type: Any,
                  function: String = #function,
                  line: UInt = #line) throws {
        
        guard self >= 0 else {
            let debugInformation = SDLError.DebugInformation(file: file, type: type, function: function, line: line)
            guard let error = SDLError.current(debugInformation: debugInformation) else {
                assertionFailure("No error for error code \(self)")
                throw SDLError(errorMessage: "Error code \(self)", debugInformation: debugInformation)
            }
            throw error
        }
    }
}

internal extension Optional {
    
    /// Unwraps optional value, throwing error if nil.
    @inline(__always)
    func sdlThrow(file: String = #file,
                  type: Any,
                  function: String = #function,
                  line: UInt = #line) throws -> Wrapped {
        
        guard let value = self else {
            let debugInformation = SDLError.DebugInformation(file: file, type: type, function: function, line: line)
            guard let error = SDLError.current(debugInformation: debugInformation) else {
                assertionFailure("No error for nil value \(Wrapped.self)")
                throw SDLError(errorMessage: "Nil value \(Wrapped.self)", debugInformation: debugInformation)
            }
            throw error
        }
        return value
    }
}
