//
//  Version.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL version number.
public struct SDLVersion: Equatable, Hashable, Sendable {

    public var major: UInt8

    public var minor: UInt8

    public var patch: UInt8

    public init(major: UInt8, minor: UInt8, patch: UInt8) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    internal init(_ version: SDL_version) {
        self.major = version.major
        self.minor = version.minor
        self.patch = version.patch
    }
}

public extension SDLVersion {

    /// The version of SDL the application was compiled against.
    static var compiled: SDLVersion {
        SDLVersion(
            major: UInt8(SDL_MAJOR_VERSION),
            minor: UInt8(SDL_MINOR_VERSION),
            patch: UInt8(SDL_PATCHLEVEL)
        )
    }

    /// The version of SDL that is linked against the application at runtime.
    static var linked: SDLVersion {
        guard let pointer = SDL_Linked_Version() else {
            return .compiled
        }
        return SDLVersion(pointer.pointee)
    }
}

// MARK: - Comparable

extension SDLVersion: Comparable {

    public static func < (lhs: SDLVersion, rhs: SDLVersion) -> Bool {
        return (lhs.major, lhs.minor, lhs.patch) < (rhs.major, rhs.minor, rhs.patch)
    }
}

// MARK: - CustomStringConvertible

extension SDLVersion: CustomStringConvertible {

    public var description: String {
        return "\(major).\(minor).\(patch)"
    }
}
