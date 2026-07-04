//
//  DisplayMode.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

import CSDL3

/// SDL Display Mode
public struct SDLDisplayMode {

    @usableFromInline
    internal let internalValue: SDL_DisplayMode

    internal init(_ internalValue: SDL_DisplayMode) {
        self.internalValue = internalValue
    }

    /// The display this mode is associated with.
    public var display: SDLVideoDisplay {
        return SDLVideoDisplay(rawValue: internalValue.displayID)
    }

    public var format: SDLPixelFormat.Format {
        return SDLPixelFormat.Format(rawValue: internalValue.format.rawValue)
    }

    /// Width, in screen coordinates
    public var width: Int {
        return Int(internalValue.w)
    }

    /// Height, in screen coordinates
    public var height: Int {
        return Int(internalValue.h)
    }

    /// Scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
    public var pixelDensity: Double {
        return Double(internalValue.pixel_density)
    }

    /// Refresh rate (in Hz), or 0 for unspecified
    public var refreshRate: Double {
        return Double(internalValue.refresh_rate)
    }
}

public extension SDLDisplayMode {

    /// Fill in information about the desktop display mode.
    init(display: SDLVideoDisplay) throws(SDLError) {

        let pointer = try SDL_GetDesktopDisplayMode(display.rawValue).sdlThrow(type: "SDLDisplayMode")
        self.init(pointer.pointee)
    }

    /// Fill in information about the current display mode.
    init(currentModeOf display: SDLVideoDisplay) throws(SDLError) {

        let pointer = try SDL_GetCurrentDisplayMode(display.rawValue).sdlThrow(type: "SDLDisplayMode")
        self.init(pointer.pointee)
    }
}
