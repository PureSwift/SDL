//
//  Renderer.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Renderer
public final class SDLRenderer {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyRenderer(internalPointer)
    }
    
    /// Create a 2D rendering context for a window.
    public init(window: SDLWindow,
                driver: SDLRenderer.Driver = .default,
                options: BitMaskOptionSet<SDLRenderer.Option> = []) throws(SDLError) {
        
        let internalPointer = SDL_CreateRenderer(window.internalPointer, Int32(driver.rawValue), options.rawValue)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLRenderer")
    }
    
    /// The color used for drawing operations (Rect, Line and Clear).
    public func drawColor() throws(SDLError) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        var red: UInt8 = 0
        var green: UInt8 = 0
        var blue: UInt8 = 0
        var alpha: UInt8 = 0
        
        try SDL_GetRenderDrawColor(internalPointer, &red, &green, &blue, &alpha).sdlThrow(type: "SDLRenderer")
        
        return (red, green, blue, alpha)
    }
    
    /// Set the color used for drawing operations (Rect, Line and Clear).
    public func setDrawColor(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) throws(SDLError) {
        
         try SDL_SetRenderDrawColor(internalPointer, red, green, blue, alpha).sdlThrow(type: "SDLRenderer")
    }
    
    /// Current rendering target texture.
    public private(set) var target: SDLTexture?
    
    /// Set a texture as the current rendering target.
    public func setTarget(_ newValue: SDLTexture?) throws(SDLError) {
        
        try SDL_SetRenderTarget(internalPointer, target?.internalPointer).sdlThrow(type: "SDLRenderer")
        
        // hold reference
        self.target = newValue
    }
    
    /// The blend mode used for drawing operations (Fill and Line).
    public func drawBlendMode() throws(SDLError) -> BitMaskOptionSet<SDLBlendMode> {
        
        var value = SDL_BlendMode(0)
        SDL_GetRenderDrawBlendMode(internalPointer, &value)
        return BitMaskOptionSet<SDLBlendMode>(rawValue: value.rawValue)
    }
    
    /// Set the blend mode used for drawing operations (Fill and Line).
    ///
    /// - Note: If the blend mode is not supported, the closest supported mode is chosen.
    public func setDrawBlendMode(_ newValue: BitMaskOptionSet<SDLBlendMode>) throws(SDLError) {
        
        try SDL_SetRenderDrawBlendMode(internalPointer, SDL_BlendMode(newValue.rawValue)).sdlThrow(type: "SDLRenderer")
    }
    
    /// Set a device independent resolution for rendering
    public func setLogicalSize(width: Int32, height: Int32) throws(SDLError) {
        
        try SDL_RenderSetLogicalSize(internalPointer, width, height).sdlThrow(type: "SDLRenderer")
    }
    
    // MARK: - Methods
    
    /// Clear the current rendering target with the drawing color
    /// This function clears the entire rendering target, ignoring the viewport.
    public func clear() throws(SDLError) {
        
        try SDL_RenderClear(internalPointer).sdlThrow(type: "SDLRenderer")
    }
    
    /// Update the screen with rendering performed.
    public func present() {
        
        SDL_RenderPresent(internalPointer)
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source: SDL_Rect, destination: SDL_Rect) throws(SDLError) {
        var s = source
        var d = destination
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: "SDLRenderer")
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source s: inout SDL_Rect, destination d: inout SDL_Rect) throws(SDLError) {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: "SDLRenderer")
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source: SDL_Rect) throws(SDLError) {
        var s = source
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: "SDLRenderer")
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source s: inout SDL_Rect) throws(SDLError) {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: "SDLRenderer")
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, destination: SDL_Rect) throws(SDLError) {
        var d = destination
        try SDL_RenderCopy(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: "SDLRenderer")
    }
    
    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, destination d: inout SDL_Rect) throws(SDLError) {
        try SDL_RenderCopy(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: "SDLRenderer")
    }
    
    /// Fill a rectangle on the current rendering target with the drawing color.
    public func fill(rect: SDL_Rect? = nil) throws(SDLError) {
        
        let rectPointer: UnsafePointer<SDL_Rect>?
        if let rect = rect {
            rectPointer = withUnsafePointer(to: rect) { $0 }
        } else {
            rectPointer = nil
        }
        
        try SDL_RenderFillRect(internalPointer, rectPointer).sdlThrow(type: "SDLRenderer")
    }

    /// Draw the outline of a rectangle on the current rendering target with the drawing color.
    public func draw(rect: SDL_Rect? = nil) throws(SDLError) {

        let rectPointer: UnsafePointer<SDL_Rect>?
        if let rect = rect {
            rectPointer = withUnsafePointer(to: rect) { $0 }
        } else {
            rectPointer = nil
        }

        try SDL_RenderDrawRect(internalPointer, rectPointer).sdlThrow(type: "SDLRenderer")
    }

    /// Copy a portion of the texture to the current rendering target, rotating it around a
    /// center point and optionally flipping it.
    public func copy(_ texture: SDLTexture, source: SDL_Rect? = nil, destination: SDL_FRect? = nil,
                      angle: Double, center: SDL_FPoint? = nil, flip: BitMaskOptionSet<Flip> = []) throws(SDLError) {

        try withOptionalUnsafePointer(to: source) { sourcePointer throws(SDLError) in
            try withOptionalUnsafePointer(to: destination) { destinationPointer throws(SDLError) in
                try withOptionalUnsafePointer(to: center) { centerPointer throws(SDLError) in
                    try SDL_RenderCopyExF(
                        internalPointer,
                        texture.internalPointer,
                        sourcePointer,
                        destinationPointer,
                        angle,
                        centerPointer,
                        SDL_RendererFlip(rawValue: flip.rawValue)
                    ).sdlThrow(type: "SDLRenderer")
                }
            }
        }
    }

    /// Render a list of colored triangles.
    public func drawGeometry(vertices: [(position: SDL_FPoint, color: VertexColor)]) throws(SDLError) {

        let sdlVertices = vertices.map {
            SDL_Vertex(position: $0.position, color: $0.color.internalValue, tex_coord: SDL_FPoint(x: 0, y: 0))
        }

        try sdlVertices.withUnsafeBufferPointer { buffer throws(SDLError) in
            try SDL_RenderGeometry(internalPointer, nil, buffer.baseAddress, Int32(buffer.count), nil, 0).sdlThrow(type: "SDLRenderer")
        }
    }

    /// Convert window coordinates to coordinates in the rendering target's coordinate space.
    public func renderCoordinates(fromWindow point: (x: Float, y: Float)) -> (x: Float, y: Float) {

        var x: Float = 0
        var y: Float = 0
        SDL_RenderWindowToLogical(internalPointer, Int32(point.x), Int32(point.y), &x, &y)
        return (x, y)
    }

    /// Convert coordinates in the rendering target's coordinate space to window coordinates.
    public func windowCoordinates(fromRender point: (x: Float, y: Float)) -> (x: Float, y: Float) {

        var x: Int32 = 0
        var y: Int32 = 0
        SDL_RenderLogicalToWindow(internalPointer, point.x, point.y, &x, &y)
        return (Float(x), Float(y))
    }
}

// MARK: - Supporting Types

/// Attempts to obtain an `UnsafePointer` to `value`, calling `body` with `nil` if `value` is `nil`.
internal func withOptionalUnsafePointer<T, Result>(
    to value: T?,
    _ body: (UnsafePointer<T>?) throws(SDLError) -> Result
) throws(SDLError) -> Result {

    guard var value else { return try body(nil) }
    do { return try withUnsafePointer(to: &value) { try body($0) } }
    catch { throw error as! SDLError } // compiler error
}

public extension SDLRenderer {

    /// Flipping actions that can be performed when copying a texture.
    enum Flip: UInt32, BitMaskOption {

        case horizontal = 0x01
        case vertical = 0x02
    }
}

public extension SDLRenderer {

    /// A color used for `drawGeometry(vertices:)`, independent of a pixel format.
    struct VertexColor: Equatable, Hashable, Sendable {

        public var red: Float
        public var green: Float
        public var blue: Float
        public var alpha: Float

        public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }

        internal var internalValue: SDL_Color {
            SDL_Color(r: UInt8((red * 255).rounded()), g: UInt8((green * 255).rounded()), b: UInt8((blue * 255).rounded()), a: UInt8((alpha * 255).rounded()))
        }
    }
}

public extension SDLRenderer {
    
    /// An enumeration of flags used when creating a rendering context.
    enum Option: UInt32, BitMaskOption {
        
        /// The renderer is a software fallback.
        case software = 0x00000001
        
        /// The renderer uses hardware acceleration.
        case accelerated = 0x00000002
        
        /// Present is synchronized with the refresh rate
        case presentVsync = 0x00000004
        
        /// The renderer supports rendering to texture
        case targetTexture = 0x00000008
    }
    
}

public extension SDLRenderer {
    
    /// Information on the capabilities of a render driver or context.
    struct Info {
        
        /// The name of the renderer.
        public let name: String
        
        /// Supported options.
        public let options: BitMaskOptionSet<SDLRenderer.Option>
        
        /// The number of available texture formats.
        public let formats: [SDLPixelFormat.Format]
        
        /// The maximimum texture size.
        public let maximumSize: (width: Int, height: Int)
        
        public init(driver: Driver) throws(SDLError) {
            
            // get driver info from SDL
            var info = SDL_RendererInfo()
            try SDL_GetRenderDriverInfo(Int32(driver.rawValue), &info).sdlThrow(type: "SDLRenderer.Info")
            
            self.init(info)
        }
        
        internal init(_ info: SDL_RendererInfo) {
            
            self.name = String(cString: info.name)
            self.options = BitMaskOptionSet<SDLRenderer.Option>(rawValue: info.flags)
            self.maximumSize = (Int(info.max_texture_width), Int(info.max_texture_height))
            
            // copy formats array
            let formatsCount = Int(info.num_texture_formats)
            let formats = [info.texture_formats.0,
                           info.texture_formats.1,
                           info.texture_formats.2,
                           info.texture_formats.3,
                           info.texture_formats.4,
                           info.texture_formats.5,
                           info.texture_formats.6,
                           info.texture_formats.7,
                           info.texture_formats.8,
                           info.texture_formats.9,
                           info.texture_formats.10,
                           info.texture_formats.11,
                           info.texture_formats.12,
                           info.texture_formats.13,
                           info.texture_formats.14,
                           info.texture_formats.15]
            
            self.formats = formats.prefix(formatsCount).map { SDLPixelFormat.Format(rawValue: $0) }
        }
    }
}

public extension SDLRenderer {
    
    struct Driver: IndexRepresentable {
        
        public static var all: CountableSet<Driver> {
            
            let count = Int(SDL_GetNumRenderDrivers())
            return CountableSet<Driver>(count: count)
        }
        
        public static var `default`: Driver { Driver(rawValue: -1) }
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            
            self.rawValue = rawValue
        }
    }
}
