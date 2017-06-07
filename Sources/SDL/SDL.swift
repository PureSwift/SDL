import CSDL2

/// [Simple DirectMedia Layer](https://wiki.libsdl.org/)
public struct SDL {
    
    /// Use this function to initialize the SDL library.
    /// You should specify the subsystems which you will be using in your application
    ///
    /// - Note: This must be called before using most other SDL functions.
    @inline(__always)
    public static func initialize(subSystems: Set<SubSystem>) -> Bool {
                
        return SDL_Init(subSystems.flags) > 0
    }
    
    /// Cleans up all initialized subsystems.
    ///
    /// You should call it upon all exit conditions.
    @inline(__always)
    public static func quit() {
        SDL_Quit()
    }
    
    /// Cleans up specific SDL subsystems
    @inline(__always)
    public static func quit(subSystems: Set<SubSystem>) {
        
        return SDL_QuitSubSystem(subSystems.flags)
    }
    
    /// Get a string descripbing the current error.
    public static var errorDescription: String? {
        
        guard let cString = SDL_GetError()
            else { return nil }
        
        return String(cString: cString)
    }
}

// MARK: - Supporting Types

public extension SDL {
    
    /// Specific SDL subsystems.
    public enum SubSystem: UInt32 {
        
        case timer = 0x00000001
        case audio = 0x00000010
        case video = 0x00000020
        case joystick = 0x00000200
        case haptic = 0x00001000
        case gameController = 0x00002000
        case events = 0x00004000
        
        /// All the SDL subsystems.
        public static let all: Set<SubSystem> = [.timer, .audio, .video, .joystick, .haptic, .gameController, .events]
    }
}

// MARK: - Internal Extensions

/// Convert Swift enums for option flags into their raw values OR'd.
internal extension Collection where Element: RawRepresentable, Element.RawValue: FixedWidthInteger {
    
    var flags: Element.RawValue {
        
        @inline(__always)
        get { return reduce(0, { $0 | $1.rawValue }) }
    }
}
