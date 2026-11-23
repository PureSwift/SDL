//
//  AppMetadata.swift
//  SDL3
//

import CSDL3

public extension SDL {

    /// Describe the app to the system, such as its identifier
    /// (`SDL_PROP_APP_METADATA_IDENTIFIER_STRING`), which becomes the
    /// Wayland `app_id` and X11 window class of windows made after it's set.
    /// `nil` clears a property.
    static func setAppMetadataProperty(_ name: String, _ value: String?) throws(SDLError) {
        try SDL_SetAppMetadataProperty(name, value).sdlThrow(type: "SDL")
    }

    /// A property describing the app, or `nil` if it's unset.
    static func appMetadataProperty(_ name: String) -> String? {
        SDL_GetAppMetadataProperty(name).map { String(cString: $0) }
    }
}
