//
//  Error.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL2

/// SDL Error
public struct SDLError: Error {

    public let errorMessage: String

    public let context: Context?

    public init(errorMessage: String, context: Context? = nil) {
        self.errorMessage = errorMessage
        self.context = context
    }
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
        
        public init(file: String,
                      type: StaticString,
                      function: String,
                      line: UInt) {

            self.file = file
            self.function = function
            self.line = line
            self.type = type.description
        }
        
        public var description: String {
            let fileName = file.split(separator: "/").last.flatMap { String($0) } ?? file
            return "\(fileName):\(line.description) \(type).\(function)"
        }
    }
}

public extension SDLError {
    
    /// Text for last reported error.
    static func current(context: Context? = nil) -> SDLError? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        SDL_ClearError() // reset error
        let errorDescription = String(cString: cString)
        
        return SDLError(errorMessage: errorDescription, context: context)
    }
}

public extension CInt {
    
    /// Throws for error codes.
    @inline(__always)
    func sdlThrow(
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        type: StaticString
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

public extension Optional {

    /// Unwraps optional value, throwing error if nil.
    @inline(__always)
    func sdlThrow(file: String = #file,
                  function: String = #function,
                  line: UInt = #line,
                  type: StaticString) throws(SDLError) -> Wrapped {

        guard let value = self else {
            let context = SDLError.Context(file: file, type: type, function: function, line: line)
            guard let error = SDLError.current(context: context) else {
                assertionFailure("No error for nil value")
                throw SDLError(errorMessage: "Nil value (" + type.description + ")", context: context)
            }
            throw error
        }
        return value
    }
}
