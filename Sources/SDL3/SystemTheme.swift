//
//  SystemTheme.swift
//  SDL3
//

import CSDL3

/// Whether the system shows light or dark windows.
public enum SDLSystemTheme: Equatable, Hashable, Sendable {

    /// The system doesn't say.
    case unknown

    case light

    case dark
}

public extension SDL {

    /// The system's current theme.
    static var systemTheme: SDLSystemTheme {
        switch SDL_GetSystemTheme() {
        case SDL_SYSTEM_THEME_LIGHT: .light
        case SDL_SYSTEM_THEME_DARK: .dark
        default: .unknown
        }
    }
}
