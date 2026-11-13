//
//  GLAttributes.swift
//  SDL3
//

import CSDL3

public extension GLAttribute {

    static var alphaSize: GLAttribute { GLAttribute(rawValue: SDL_GL_ALPHA_SIZE.rawValue) }
    static var doubleBuffer: GLAttribute { GLAttribute(rawValue: SDL_GL_DOUBLEBUFFER.rawValue) }
    static var depthSize: GLAttribute { GLAttribute(rawValue: SDL_GL_DEPTH_SIZE.rawValue) }
    static var stencilSize: GLAttribute { GLAttribute(rawValue: SDL_GL_STENCIL_SIZE.rawValue) }
}
