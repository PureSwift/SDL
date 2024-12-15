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
    
    public let context: Context?
}

extension SDLError: CustomStringConvertible {
    
    public var description: String {
        return errorMessage
    }
}

extension SDLError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var description = errorMessage
        if let context {
            description += " " + "(\(context.description))"
        }
        return description
    }
}

public extension SDLError {
    
    struct Context: CustomStringConvertible, Sendable {
        
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
    static func current(context: Context? = nil) -> SDLError? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        SDL_ClearError() // reset error
        let errorDescription = String(cString: cString)
        
        return SDLError(errorMessage: errorDescription, context: context)
    }
}

internal extension CInt {
    
    /// Throws for error codes.
    @inline(__always)
    func sdlThrow(
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        type: Any
    ) throws(SDLError) {
        
        guard self >= 0 else {
            let context = SDLError.Context(file: file, type: type, function: function, line: line)
            guard let error = SDLError.current(context: context) else {
                assertionFailure("No error for error code \(self)")
                throw SDLError(errorMessage: "Error code \(self)", context: context)
            }
            throw error
        }
    }
}

internal extension Optional {
    
    /// Unwraps optional value, throwing error if nil.
    @inline(__always)
    func sdlThrow(file: String = #file,
                  function: String = #function,
                  line: UInt = #line,
                  type: Any) throws(SDLError) -> Wrapped {
        
        guard let value = self else {
            let context = SDLError.Context(file: file, type: type, function: function, line: line)
            guard let error = SDLError.current(context: context) else {
                assertionFailure("No error for nil value \(Wrapped.self)")
                throw SDLError(errorMessage: "Nil value \(Wrapped.self)", context: context)
            }
            throw error
        }
        return value
    }
}
