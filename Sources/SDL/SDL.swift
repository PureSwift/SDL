import CSDL2

/// [Simple DirectMedia Layer](https://wiki.libsdl.org/)
public struct SDL {
    
    /// Use this function to initialize the SDL library.
    /// You should specify the subsystems which you will be using in your application
    ///
    /// - Note: This must be called before using most other SDL functions.
    public static func initialize(subSystems: BitMaskOptionSet<SubSystem>) throws {
                
        try SDL_Init(subSystems.rawValue).sdlThrow(type: type(of: self))
    }
    
    /// Cleans up all initialized subsystems.
    ///
    /// You should call it upon all exit conditions.
    @inline(__always)
    public static func quit() {
        SDL_Quit()
    }
    
    /// Cleans up specific SDL subsystems
    public static func quit(subSystems: BitMaskOptionSet<SubSystem>) {
        
        return SDL_QuitSubSystem(subSystems.rawValue)
    }
}

// MARK: - Supporting Types

public extension SDL {
    
    /// Specific SDL subsystems.
    enum SubSystem: UInt32, BitMaskOption {
        
        case timer = 0x00000001
        case audio = 0x00000010
        case video = 0x00000020
        case joystick = 0x00000200
        case haptic = 0x00001000
        case gameController = 0x00002000
        case events = 0x00004000
    }
}
