//
//  TexturedGeometry.swift
//  SDL3
//

import CSDL3

public extension SDLRenderer {

    /// A corner of a triangle: where it's drawn, its color, and the point
    /// of a texture it shows.
    struct Vertex: Equatable, Hashable, Sendable {

        /// The position, in the rendering target's coordinates.
        public var x: Float
        public var y: Float

        /// The color, which multiplies the texture's.
        public var color: VertexColor

        /// The point of the texture, from 0 to 1 across it.
        public var textureX: Float
        public var textureY: Float

        public init(
            x: Float,
            y: Float,
            color: VertexColor = VertexColor(red: 1, green: 1, blue: 1),
            textureX: Float = 0,
            textureY: Float = 0
        ) {
            self.x = x
            self.y = y
            self.color = color
            self.textureX = textureX
            self.textureY = textureY
        }

        internal var internalValue: SDL_Vertex {
            SDL_Vertex(
                position: SDL_FPoint(x: x, y: y),
                color: color.internalValue,
                tex_coord: SDL_FPoint(x: textureX, y: textureY)
            )
        }
    }

    /// Render triangles, colored and optionally showing a texture.
    ///
    /// - Parameter texture: The texture the triangles show, or `nil` for
    ///   their vertices' colors alone.
    /// - Parameter indices: Which vertices make each triangle, three at a
    ///   time, or `nil` to take the vertices in order.
    func drawGeometry(texture: SDLTexture? = nil, vertices: [Vertex], indices: [Int32]? = nil) throws(SDLError) {
        let raw = vertices.map(\.internalValue)
        let drawn: Bool = raw.withUnsafeBufferPointer { buffer in
            if let indices {
                return indices.withUnsafeBufferPointer { index in
                    SDL_RenderGeometry(
                        internalPointer, texture?.internalPointer,
                        buffer.baseAddress, Int32(buffer.count), index.baseAddress, Int32(index.count)
                    )
                }
            }
            return SDL_RenderGeometry(internalPointer, texture?.internalPointer, buffer.baseAddress, Int32(buffer.count), nil, 0)
        }
        try drawn.sdlThrow(type: "SDLRenderer")
    }
}
