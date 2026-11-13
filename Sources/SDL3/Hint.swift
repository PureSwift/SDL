//
//  Hint.swift
//  SDL3
//

import CSDL3

public extension SDL {

    /// Set a configuration hint, such as `SDL_VIDEO_FORCE_EGL`, with its value.
    @discardableResult
    static func setHint(_ name: String, _ value: String) -> Bool {
        SDL_SetHint(name, value)
    }

    /// Start a subsystem on its own.
    static func initialize(subSystem: SubSystem) throws(SDLError) {
        try SDL_InitSubSystem(subSystem.rawValue).sdlThrow(type: "SDL")
    }
}
