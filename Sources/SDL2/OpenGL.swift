//
//  OpenGL.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL2

/// SDL OpenGL Context
public final class SDLGLContext {

    // MARK: - Properties

    internal let internalPointer: SDL_GLContext

    // MARK: - Initialization

    deinit {
        SDL_GL_DeleteContext(internalPointer)
    }

    /// Create an OpenGL context for use with an OpenGL window, and make it current.
    public init(window: SDLWindow) throws(SDLError) {

        let internalPointer = SDL_GL_CreateContext(window.internalPointer)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLGLContext")
    }

    // MARK: - Methods

    /// Set up this OpenGL context for rendering into the given window.
    public func makeCurrent(in window: SDLWindow) throws(SDLError) {

        try SDL_GL_MakeCurrent(window.internalPointer, internalPointer).sdlThrow(type: "SDLGLContext")
    }
}

// MARK: - SDLWindow

public extension SDLWindow {

    /// Update a window with OpenGL rendering.
    func glSwap() {

        SDL_GL_SwapWindow(internalPointer)
    }
}

// MARK: - SDL

public extension SDL {

    /// Set an OpenGL window attribute before window creation.
    static func glSetAttribute(_ attribute: GLAttribute, _ value: Int32) throws(SDLError) {

        try SDL_GL_SetAttribute(attribute.sdlValue, value).sdlThrow(type: "SDL")
    }

    /// Get the actual value for an attribute from the current context.
    static func glGetAttribute(_ attribute: GLAttribute) throws(SDLError) -> Int32 {

        var value: Int32 = 0
        try SDL_GL_GetAttribute(attribute.sdlValue, &value).sdlThrow(type: "SDL")
        return value
    }

    /// Get an OpenGL function by name.
    static func glProcAddress(_ name: String) -> UnsafeMutableRawPointer? {

        SDL_GL_GetProcAddress(name)
    }

    /// The swap interval for the current OpenGL context.
    static var glSwapInterval: Int32 {
        SDL_GL_GetSwapInterval()
    }

    /// Set the swap interval for the current OpenGL context.
    static func glSetSwapInterval(_ interval: Int32) throws(SDLError) {

        try SDL_GL_SetSwapInterval(interval).sdlThrow(type: "SDL")
    }
}

// MARK: - Supporting Types

/// An OpenGL context attribute.
public struct GLAttribute: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    internal var sdlValue: SDL_GLattr {
        SDL_GLattr(rawValue: rawValue)
    }

    public static var contextProfileMask: GLAttribute { GLAttribute(rawValue: SDL_GL_CONTEXT_PROFILE_MASK.rawValue) }
    public static var contextMajorVersion: GLAttribute { GLAttribute(rawValue: SDL_GL_CONTEXT_MAJOR_VERSION.rawValue) }
    public static var contextMinorVersion: GLAttribute { GLAttribute(rawValue: SDL_GL_CONTEXT_MINOR_VERSION.rawValue) }
    public static var multisampleBuffers: GLAttribute { GLAttribute(rawValue: SDL_GL_MULTISAMPLEBUFFERS.rawValue) }
    public static var multisampleSamples: GLAttribute { GLAttribute(rawValue: SDL_GL_MULTISAMPLESAMPLES.rawValue) }
    public static var shareWithCurrentContext: GLAttribute { GLAttribute(rawValue: SDL_GL_SHARE_WITH_CURRENT_CONTEXT.rawValue) }
}

public extension GLAttribute {

    /// Values for the `contextProfileMask` attribute.
    struct Profile: RawRepresentable, Equatable, Hashable, Sendable {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static var core: Profile { Profile(rawValue: Int32(SDL_GL_CONTEXT_PROFILE_CORE.rawValue)) }
        public static var compatibility: Profile { Profile(rawValue: Int32(SDL_GL_CONTEXT_PROFILE_COMPATIBILITY.rawValue)) }
        public static var es: Profile { Profile(rawValue: Int32(SDL_GL_CONTEXT_PROFILE_ES.rawValue)) }
    }
}
