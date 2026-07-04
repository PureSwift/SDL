import CSDL3

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
    public static var ticks: UInt64 {
        SDL_GetTicksNS()
    }

    /// Wait the specified number of nanoseconds before returning.
    public static func delay(nanoseconds: UInt64) {
        SDL_DelayNS(nanoseconds)
    }

    /// Open a URL/URI in the browser or other appropriate external application.
    public static func open(url: String) throws(SDLError) {
        try SDL_OpenURL(url).sdlThrow(type: "SDL")
    }

    /// The default playback audio device.
    public static var defaultPlaybackAudioDevice: AudioDeviceID {
        AudioDeviceID(rawValue: SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK)
    }
}

/// An audio device identifier.
public struct AudioDeviceID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

// MARK: - Supporting Types

public extension SDL {

    /// Specific SDL subsystems.
    enum SubSystem: UInt32, BitMaskOption {

        case audio = 0x00000010
        case video = 0x00000020
        case joystick = 0x00000200
        case haptic = 0x00001000
        case gamepad = 0x00002000
        case events = 0x00004000
        case sensor = 0x00008000
        case camera = 0x00010000
    }
}
