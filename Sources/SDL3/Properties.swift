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
