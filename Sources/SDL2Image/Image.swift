//
//  Image.swift
//  SDL2Image
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import SDL2Swift
import CSDL2Image

public extension SDLSurface {

    /// Load an image file (any format supported by `SDL_image`) into a new surface.
    convenience init(contentsOfFile path: String) throws(SDLError) {

        let pointer = IMG_Load(path)
        self.init(unsafePointer: try pointer.sdlThrow(type: "SDLSurface"))
    }
}

public extension SDLTexture {

    /// Load an image file (any format supported by `SDL_image`) directly into a new texture.
    convenience init(renderer: SDLRenderer, contentsOfFile path: String) throws(SDLError) {

        let pointer = IMG_LoadTexture(renderer.unsafePointer, path)
        self.init(unsafePointer: try pointer.sdlThrow(type: "SDLTexture"))
    }
}
