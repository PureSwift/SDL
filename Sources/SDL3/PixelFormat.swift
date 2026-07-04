//
//  PixelFormat.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

/// SDL Pixel Format
public final class SDLPixelFormat {

    // MARK: - Properties

    /// Details for this pixel format.
    ///
    /// - Note: This comes from a shared global cache (i.e. not newly allocated), and hence should not be modified.
    internal let internalPointer: UnsafePointer<SDL_PixelFormatDetails>

    // MARK: - Initialization

    /// Creates a new Pixel Format.
    public init(format: SDLPixelFormat.Format) throws(SDLError) {

        let internalFormat = SDL_GetPixelFormatDetails(SDL_PixelFormat(rawValue: format.rawValue))
        self.internalPointer = try internalFormat.sdlThrow(type: type(of: self))
    }

    // MARK: - Accessors

    /// Pixel format
    public var format: SDLPixelFormat.Format {

        return Format(rawValue: internalPointer.pointee.format.rawValue)
    }
}

// MARK: - Supporting Types

public extension SDLPixelFormat {

    /// SDL Pixel Format Enum
    struct Format: RawRepresentable, Equatable, Hashable {

        public let rawValue: UInt32

        public init(rawValue: UInt32) {

            self.rawValue = rawValue
        }
    }
}

internal extension SDLPixelFormat.Format {

    /// Get the human readable name of a pixel format
    var formatName: String {
        return String(cString: SDL_GetPixelFormatName(SDL_PixelFormat(rawValue: rawValue)))
    }
}

public extension SDLPixelFormat.Format {

    /// SDL_PIXELFORMAT_INDEX1LSB
    static var index1LSB: SDLPixelFormat.Format { SDLPixelFormat.Format(rawValue: SDL_PIXELFORMAT_INDEX1LSB.rawValue) }

    /// SDL_PIXELFORMAT_INDEX1MSB
    static var index1MSB: SDLPixelFormat.Format { SDLPixelFormat.Format(rawValue: SDL_PIXELFORMAT_INDEX1MSB.rawValue) }

    /// SDL_PIXELFORMAT_ARGB32
    static var argb32: SDLPixelFormat.Format { SDLPixelFormat.Format(rawValue: SDL_PIXELFORMAT_ARGB32.rawValue) }

    /// SDL_PIXELFORMAT_ARGB8888
    static var argb8888: SDLPixelFormat.Format { SDLPixelFormat.Format(rawValue: SDL_PIXELFORMAT_ARGB8888.rawValue) }
}

// MARK: - ExpressibleByIntegerLiteral

extension SDLPixelFormat.Format: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension SDLPixelFormat.Format: CustomStringConvertible {

    /// Get the human readable name of a pixel format.
    public var description: String {

        let name = formatName
        return name.split(separator: "_").last.flatMap { String($0) } ?? name
    }
}

// MARK: - CustomStringDebugConvertible

extension SDLPixelFormat.Format: CustomDebugStringConvertible {

    public var debugDescription: String {

        return formatName
    }
}
