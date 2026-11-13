//
//  Properties.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

/// An SDL properties group identifier.
public struct SDLProperties: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: SDL_PropertiesID

    public init(rawValue: SDL_PropertiesID) {
        self.rawValue = rawValue
    }
}

public extension SDLProperties {

    /// Get a boolean property.
    func boolean(_ name: String, default defaultValue: Bool = false) -> Bool {
        SDL_GetBooleanProperty(rawValue, name, defaultValue)
    }
}

public extension SDLProperties {

    /// Get a number property.
    func number(_ name: String, default defaultValue: Int64 = 0) -> Int64 {
        SDL_GetNumberProperty(rawValue, name, defaultValue)
    }
}

public extension SDLTexture {

    /// The texture's properties, such as the renderer's own handle for it.
    var properties: SDLProperties {
        SDLProperties(rawValue: SDL_GetTextureProperties(internalPointer))
    }

    /// The underlying `SDL_Texture` pointer, for interop with other `SDL_*` C APIs.
    var unsafePointer: OpaquePointer {
        OpaquePointer(internalPointer)
    }
}
