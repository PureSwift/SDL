//
//  VideoDisplay.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL3

/// SDL Video Display
public struct SDLVideoDisplay: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {

        self.rawValue = rawValue
    }
}

public extension SDLVideoDisplay {

    /// All currently connected displays.
    static var all: [SDLVideoDisplay] {

        var count: Int32 = 0
        guard let pointer = SDL_GetDisplays(&count)
            else { return [] }

        defer { SDL_free(pointer) }

        return (0 ..< Int(count)).map { SDLVideoDisplay(rawValue: pointer[$0]) }
    }

    /// The primary display.
    static var primary: SDLVideoDisplay {

        SDLVideoDisplay(rawValue: SDL_GetPrimaryDisplay())
    }
}

public extension SDLVideoDisplay {

    /// Get the closest match to the requested display mode.
    ///
    /// The available display modes are scanned, and closest is filled in with the closest mode
    /// matching the requested mode and returned.
    func closestDisplayMode(width: Int, height: Int, refreshRate: Float = 0, includeHighDensityModes: Bool = false) -> SDLDisplayMode? {

        var closest = SDL_DisplayMode()
        guard SDL_GetClosestFullscreenDisplayMode(rawValue, Int32(width), Int32(height), refreshRate, includeHighDensityModes, &closest)
            else { return nil }

        return SDLDisplayMode(closest)
    }

    /// Get the availible display modes.
    func modes() throws(SDLError) -> [SDLDisplayMode] {

        var count: Int32 = 0
        let pointer = try SDL_GetFullscreenDisplayModes(rawValue, &count).sdlThrow(type: type(of: self))

        defer { SDL_free(pointer) }

        return (0 ..< Int(count)).compactMap { pointer[$0].map { SDLDisplayMode($0.pointee) } }
    }
}
