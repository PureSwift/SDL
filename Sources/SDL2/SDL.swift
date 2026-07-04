import CSDL2

/// [Simple DirectMedia Layer](https://wiki.libsdl.org/)
public struct SDL {
    
    /// Use this function to initialize the SDL library.
    /// You should specify the subsystems which you will be using in your application
    ///
    /// - Note: This must be called before using most other SDL functions.
    public static func initialize(subSystems: BitMaskOptionSet<SubSystem>) throws(SDLError) {
                
        try SDL_Init(subSystems.rawValue).sdlThrow(type: "SDL")
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

    /// The number of nanoseconds since SDL library initialization.
    ///
    /// - Note: SDL2 has no nanosecond-precision tick counter, so this is reconstructed from
    ///   `SDL_GetPerformanceCounter()` / `SDL_GetPerformanceFrequency()`.
    public static var ticks: UInt64 {
        let counter = SDL_GetPerformanceCounter()
        let frequency = SDL_GetPerformanceFrequency()
        let whole = counter / frequency
        let remainder = counter % frequency
        return whole &* 1_000_000_000 &+ (remainder &* 1_000_000_000) / frequency
    }

    /// Wait the specified number of nanoseconds before returning.
    public static func delay(nanoseconds: UInt64) {
        SDL_Delay(UInt32(nanoseconds / 1_000_000))
    }

    /// Open a URL/URI in the browser or other appropriate external application.
    public static func open(url: String) throws(SDLError) {
        try SDL_OpenURL(url).sdlThrow(type: "SDL")
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
