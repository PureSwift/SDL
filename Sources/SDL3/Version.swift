//
//  Version.swift
//  SDL3
//

import CSDL3

/// A version of SDL.
public struct SDLVersion: RawRepresentable, Equatable, Hashable, Comparable, Sendable {

    /// The version as SDL numbers it: `major * 1000000 + minor * 1000 + micro`.
    public let rawValue: Int32

    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public init(major: Int, minor: Int, micro: Int) {
        self.rawValue = Int32(major * 1_000_000 + minor * 1_000 + micro)
    }

    public var major: Int { Int(rawValue) / 1_000_000 }

    public var minor: Int { Int(rawValue) / 1_000 % 1_000 }

    public var micro: Int { Int(rawValue) % 1_000 }

    public static func < (lhs: SDLVersion, rhs: SDLVersion) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension SDLVersion: CustomStringConvertible {

    public var description: String {
        "\(major).\(minor).\(micro)"
    }
}

public extension SDL {

    /// The version of the SDL library linked at run time, which may differ
    /// from the one the app was compiled against.
    static var version: SDLVersion {
        SDLVersion(rawValue: SDL_GetVersion())
    }
}
