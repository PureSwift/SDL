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

    /// Create a group of properties, such as the options for a window. The
    /// caller destroys it.
    static func create() throws(SDLError) -> SDLProperties {
        let id = SDL_CreateProperties()
        try (id != 0).sdlThrow(type: "SDLProperties")
        return SDLProperties(rawValue: id)
    }

    /// Destroy a group of properties made with `create()`.
    func destroy() {
        SDL_DestroyProperties(rawValue)
    }

    /// Set a boolean property.
    func setBoolean(_ name: String, _ value: Bool) throws(SDLError) {
        try SDL_SetBooleanProperty(rawValue, name, value).sdlThrow(type: "SDLProperties")
    }

    /// Set a number property.
    func setNumber(_ name: String, _ value: Int64) throws(SDLError) {
        try SDL_SetNumberProperty(rawValue, name, value).sdlThrow(type: "SDLProperties")
    }

    /// Set a string property, or clear it with `nil`. SDL keeps a copy.
    func setString(_ name: String, _ value: String?) throws(SDLError) {
        try SDL_SetStringProperty(rawValue, name, value).sdlThrow(type: "SDLProperties")
    }

    /// Set a pointer property, or clear it with `nil`.
    func setPointer(_ name: String, _ value: UnsafeMutableRawPointer?) throws(SDLError) {
        try SDL_SetPointerProperty(rawValue, name, value).sdlThrow(type: "SDLProperties")
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
