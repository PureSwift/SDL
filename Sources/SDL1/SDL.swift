import CSDL

/// [Simple DirectMedia Layer](https://wiki.libsdl.org/SDL_1.2/)
public struct SDL {

    /// Use this function to initialize the SDL library.
    /// You should specify the subsystems which you will be using in your application.
    ///
    /// - Note: This must be called before using most other SDL functions.
    public static func initialize(subSystems: BitMaskOptionSet<SubSystem>) throws(SDLError) {

        try SDL_Init(subSystems.rawValue).sdlThrow(type: "SDL")
    }

    /// Initialize specific SDL subsystems after `initialize(subSystems:)` has been called.
    public static func initialize(subSystem: BitMaskOptionSet<SubSystem>) throws(SDLError) {

        try SDL_InitSubSystem(subSystem.rawValue).sdlThrow(type: "SDL")
    }

    /// Cleans up all initialized subsystems.
    ///
    /// You should call it upon all exit conditions.
    @inline(__always)
    public static func quit() {
        SDL_Quit()
    }

    /// Cleans up specific SDL subsystems.
    public static func quit(subSystems: BitMaskOptionSet<SubSystem>) {

        SDL_QuitSubSystem(subSystems.rawValue)
    }

    /// The subsystems which have been initialized.
    public static func wasInitialized(subSystems: BitMaskOptionSet<SubSystem> = .all) -> BitMaskOptionSet<SubSystem> {

        return BitMaskOptionSet<SubSystem>(rawValue: SDL_WasInit(subSystems.rawValue))
    }

    /// The number of milliseconds since the SDL library initialization.
    public static var ticks: UInt32 {
        return SDL_GetTicks()
    }

    /// Wait the specified number of milliseconds before returning.
    public static func delay(_ milliseconds: UInt32) {
        SDL_Delay(milliseconds)
    }
}

// MARK: - Supporting Types

public extension SDL {

    /// Specific SDL subsystems.
    enum SubSystem: UInt32, BitMaskOption {

        case timer = 0x00000001
        case audio = 0x00000010
        case video = 0x00000020
        case cdrom = 0x00000100
        case joystick = 0x00000200
        case noParachute = 0x00100000
        case eventThread = 0x01000000
    }
}
