//
//  Renderer.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

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
                driver: SDLRenderer.Driver = .default) throws(SDLError) {

        let internalPointer: OpaquePointer?
        if let name = driver.name {
            internalPointer = name.withCString { SDL_CreateRenderer(window.internalPointer, $0) }
        } else {
            internalPointer = SDL_CreateRenderer(window.internalPointer, nil)
        }
        self.internalPointer = try internalPointer.sdlThrow(type: type(of: self))
    }

    /// The color used for drawing operations (Rect, Line and Clear).
    public func drawColor() throws(SDLError) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {

        var red: UInt8 = 0
        var green: UInt8 = 0
        var blue: UInt8 = 0
        var alpha: UInt8 = 0

        try SDL_GetRenderDrawColor(internalPointer, &red, &green, &blue, &alpha).sdlThrow(type: type(of: self))

        return (red, green, blue, alpha)
    }

    /// Set the color used for drawing operations (Rect, Line and Clear).
    public func setDrawColor(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) throws(SDLError) {

         try SDL_SetRenderDrawColor(internalPointer, red, green, blue, alpha).sdlThrow(type: type(of: self))
    }

    /// Current rendering target texture.
    public private(set) var target: SDLTexture?

    /// Set a texture as the current rendering target.
    public func setTarget(_ newValue: SDLTexture?) throws(SDLError) {

        try SDL_SetRenderTarget(internalPointer, newValue?.internalPointer).sdlThrow(type: type(of: self))

        // hold reference
        self.target = newValue
    }

    /// The blend mode used for drawing operations (Fill and Line).
    public func drawBlendMode() throws(SDLError) -> BitMaskOptionSet<SDLBlendMode> {

        var value = SDL_BlendMode(0)
        try SDL_GetRenderDrawBlendMode(internalPointer, &value).sdlThrow(type: type(of: self))
        return BitMaskOptionSet<SDLBlendMode>(rawValue: value)
    }

    /// Set the blend mode used for drawing operations (Fill and Line).
    ///
    /// - Note: If the blend mode is not supported, the closest supported mode is chosen.
    public func setDrawBlendMode(_ newValue: BitMaskOptionSet<SDLBlendMode>) throws(SDLError) {

        try SDL_SetRenderDrawBlendMode(internalPointer, SDL_BlendMode(newValue.rawValue)).sdlThrow(type: type(of: self))
    }

    /// Set a device independent resolution for rendering.
    public func setLogicalSize(width: Int32, height: Int32, presentation: LogicalPresentation = .letterbox) throws(SDLError) {

        try SDL_SetRenderLogicalPresentation(internalPointer, width, height, presentation.internalValue).sdlThrow(type: type(of: self))
    }

    /// Toggle VSync of the given renderer.
    public func setVSync(_ vsync: VSync) throws(SDLError) {

        try SDL_SetRenderVSync(internalPointer, vsync.rawValue).sdlThrow(type: type(of: self))
    }

    /// The output size in pixels of a rendering context.
    public var outputSize: (width: Int, height: Int)? {

        var width: Int32 = 0
        var height: Int32 = 0
        guard SDL_GetRenderOutputSize(internalPointer, &width, &height)
            else { return nil }

        return (Int(width), Int(height))
    }

    // MARK: - Methods

    /// Clear the current rendering target with the drawing color
    /// This function clears the entire rendering target, ignoring the viewport.
    public func clear() throws(SDLError) {

        try SDL_RenderClear(internalPointer).sdlThrow(type: type(of: self))
    }

    /// Update the screen with rendering performed.
    public func present() {

        SDL_RenderPresent(internalPointer)
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source: SDL_FRect, destination: SDL_FRect) throws(SDLError) {
        var s = source
        var d = destination
        try SDL_RenderTexture(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: type(of: self))
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source s: inout SDL_FRect, destination d: inout SDL_FRect) throws(SDLError) {
        try SDL_RenderTexture(internalPointer, texture.internalPointer, &s, &d).sdlThrow(type: type(of: self))
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source: SDL_FRect) throws(SDLError) {
        var s = source
        try SDL_RenderTexture(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: type(of: self))
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, source s: inout SDL_FRect) throws(SDLError) {
        try SDL_RenderTexture(internalPointer, texture.internalPointer, &s, nil).sdlThrow(type: type(of: self))
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, destination: SDL_FRect) throws(SDLError) {
        var d = destination
        try SDL_RenderTexture(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: type(of: self))
    }

    /// Copy a portion of the texture to the current rendering target.
    public func copy(_ texture: SDLTexture, destination d: inout SDL_FRect) throws(SDLError) {
        try SDL_RenderTexture(internalPointer, texture.internalPointer, nil, &d).sdlThrow(type: type(of: self))
    }

    /// Fill a rectangle on the current rendering target with the drawing color.
    public func fill(rect: SDL_FRect? = nil) throws(SDLError) {

        let rectPointer: UnsafePointer<SDL_FRect>?
        if let rect = rect {
            rectPointer = withUnsafePointer(to: rect) { $0 }
        } else {
            rectPointer = nil
        }

        try SDL_RenderFillRect(internalPointer, rectPointer).sdlThrow(type: type(of: self))
    }
}

// MARK: - Supporting Types

public extension SDLRenderer {

    /// The behavior of texture edges during rendering.
    enum LogicalPresentation {

        /// There is no logical size in effect.
        case disabled

        /// The rendered content is stretched to the output resolution.
        case stretch

        /// The rendered content is fit to the largest dimension and the other dimension is letterboxed with the clear color.
        case letterbox

        /// The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds.
        case overscan

        /// The rendered content is scaled up by integer multiples to fit the output resolution.
        case integerScale

        internal var internalValue: SDL_RendererLogicalPresentation {
            switch self {
            case .disabled: return SDL_LOGICAL_PRESENTATION_DISABLED
            case .stretch: return SDL_LOGICAL_PRESENTATION_STRETCH
            case .letterbox: return SDL_LOGICAL_PRESENTATION_LETTERBOX
            case .overscan: return SDL_LOGICAL_PRESENTATION_OVERSCAN
            case .integerScale: return SDL_LOGICAL_PRESENTATION_INTEGER_SCALE
            }
        }
    }
}

public extension SDLRenderer {

    /// VSync setting for a renderer.
    struct VSync: RawRepresentable, Equatable, Hashable {

        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        /// VSync is disabled.
        public static var disabled: VSync { VSync(rawValue: 0) }

        /// Late swap tearing (adaptive VSync).
        public static var adaptive: VSync { VSync(rawValue: -1) }

        /// VSync every `interval` refresh.
        public static func every(_ interval: Int32) -> VSync { VSync(rawValue: interval) }
    }
}

public extension SDLRenderer {

    /// Information on the capabilities of a renderer.
    struct Info {

        /// The name of the renderer.
        public let name: String

        /// Supported texture formats.
        public let formats: [SDLPixelFormat.Format]

        /// The maximimum texture size.
        public let maximumTextureSize: Int

        public init(renderer: SDLRenderer) {

            let properties = SDL_GetRendererProperties(renderer.internalPointer)

            self.name = SDL_GetRendererName(renderer.internalPointer).flatMap { String(cString: $0) } ?? ""
            self.maximumTextureSize = Int(SDL_GetNumberProperty(properties, SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER, 0))

            var formats = [SDLPixelFormat.Format]()
            if let pointer = SDL_GetPointerProperty(properties, SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER, nil) {
                let formatsPointer = pointer.assumingMemoryBound(to: SDL_PixelFormat.self)
                var index = 0
                while formatsPointer[index] != SDL_PIXELFORMAT_UNKNOWN {
                    formats.append(SDLPixelFormat.Format(rawValue: formatsPointer[index].rawValue))
                    index += 1
                }
            }
            self.formats = formats
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

        /// The name of the rendering driver, or `nil` for the default driver.
        internal var name: String? {

            guard rawValue >= 0,
                  let cString = SDL_GetRenderDriver(Int32(rawValue))
                else { return nil }

            return String(cString: cString)
        }
    }
}
