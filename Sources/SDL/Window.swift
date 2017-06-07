//
//  Window.swift
//  SDLTests
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Window {
    
    // MARK: - Properties
    
    let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyWindow(internalPointer)
    }
    
    /// Create a window with the specified position, dimensions, and flags.
    public init?(title: String, frame: (x: Position, y: Position, width: Int, height: Int), flags: UInt32) {
        
        guard let internalPointer = SDL_CreateWindow(title, frame.x.rawValue, frame.y.rawValue, Int32(frame.width), Int32(frame.height), flags)
            else { return nil }
        
        self.internalPointer = internalPointer
    }
}

// MARK: - Supporting Types

public extension Window {
    
    public enum Position: RawRepresentable {
        
        case undefined
        case centered
        case point(Int)
        
        private var SDL_WINDOWPOS_UNDEFINED: RawValue { return 0x1FFF0000 }
        private var SDL_WINDOWPOS_CENTERED: RawValue { return 0x2FFF0000 }
        
        public init?(rawValue: CInt) {
            
            switch rawValue {
            case SDL_WINDOWPOS_UNDEFINED: self = .undefined
            case SDL_WINDOWPOS_CENTERED: self = .centered
            default: self = .point(Int(rawValue))
            }
        }
        
        public var rawValue: CInt {
            
            switch self {
            case .undefined: return SDL_WINDOWPOS_UNDEFINED
            case .centered: return SDL_WINDOWPOS_CENTERED
            case let .point(point): return CInt(point)
            }
        }
    }
    
    public enum 
}
