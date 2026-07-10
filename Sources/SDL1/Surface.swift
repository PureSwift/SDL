//
//  Surface.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Surface
public final class SDLSurface {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<SDL_Surface>

    /// Whether this instance owns (and should free) the underlying surface.
    ///
    /// The screen surface returned by `SDL_SetVideoMode` is owned by SDL and must not be freed.
    internal let owned: Bool

    // MARK: - Initialization

    deinit {
        if owned {
            SDL_FreeSurface(internalPointer)
        }
    }

    internal init(internalPointer: UnsafeMutablePointer<SDL_Surface>, owned: Bool = true) {
        self.internalPointer = internalPointer
        self.owned = owned
    }

    /// Create an empty RGB surface.
    public init(
        rgb mask: (red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32),
        size: (width: Int, height: Int),
        depth: Int = 32,
        flags: BitMaskOptionSet<Flag> = []
    ) throws(SDLError) {

        let internalPointer = SDL_CreateRGBSurface(flags.rawValue, CInt(size.width), CInt(size.height), CInt(depth), mask.red, mask.green, mask.blue, mask.alpha)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLSurface")
        self.owned = true
    }

    /// Adopt an existing, unmanaged `SDL_Surface` pointer (e.g. one returned by `IMG_Load()`).
    ///
    /// - Note: Ownership of `pointer` transfers to the new `SDLSurface`; it will be freed
    ///   via `SDL_FreeSurface` when this instance deinitializes.
    public init(unsafePointer pointer: UnsafeMutablePointer<SDL_Surface>) {
        self.internalPointer = pointer
        self.owned = true
    }

    /// Load a surface from a BMP file.
    public init(bmpFile path: String) throws(SDLError) {
        let internalPointer = SDL_LoadBMP_RW(SDL_RWFromFile(path, "rb"), 1)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLSurface")
        self.owned = true
    }

    // MARK: - Accessors

    public var width: Int {
        return Int(internalPointer.pointee.w)
    }

    public var height: Int {
        return Int(internalPointer.pointee.h)
    }

    public var pitch: Int {
        return Int(internalPointer.pointee.pitch)
    }

    public var flags: BitMaskOptionSet<Flag> {
        return BitMaskOptionSet<Flag>(rawValue: internalPointer.pointee.flags)
    }

    /// The format of the pixels stored in the surface.
    public var format: SDLPixelFormat {
        return SDLPixelFormat(internalPointer.pointee.format)
    }

    /// The palette of the surface, if the pixel format is paletted.
    public var palette: SDLPalette? {
        guard let palette = internalPointer.pointee.format.pointee.palette else { return nil }
        return SDLPalette(palette)
    }

    internal var mustLock: Bool {

        // #define SDL_MUSTLOCK(surface) (surface->offset || ((surface->flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0))
        @inline(__always)
        get {
            let surface = internalPointer.pointee
            let lockFlags = UInt32(SDL_HWSURFACE) | UInt32(SDL_ASYNCBLIT) | UInt32(SDL_RLEACCEL)
            return surface.offset != 0 || (surface.flags & lockFlags) != 0
        }
    }

    // MARK: - Methods

    /// Get a pointer to the data of the surface, for direct inspection or modification.
    public func withUnsafeMutableBytes<Result, Error>(_ body: (UnsafeMutableRawPointer?) throws(Error) -> Result) throws -> Result where Error: Swift.Error {

        let mustLock = self.mustLock

        if mustLock {
            try lock()
        }

        defer {
            if mustLock {
                unlock()
            }
        }

        return try body(internalPointer.pointee.pixels)
    }

    /// Sets up a surface for directly accessing the pixels.
    ///
    /// Between calls to `lock()` / `unlock()`, you can read from and write to the surface pixels.
    /// Not all surfaces require locking; consult `mustLock`.
    internal func lock() throws(SDLError) {
        try SDL_LockSurface(internalPointer).sdlThrow(type: "SDLSurface")
    }

    internal func unlock() {
        SDL_UnlockSurface(internalPointer)
    }

    /// Perform a fast blit from this surface to the destination surface.
    public func blit(to surface: SDLSurface, source: SDLRect? = nil, destination: SDLRect? = nil) throws(SDLError) {

        try source.withUnsafeSDLPointer { sourcePointer in
            destination.withUnsafeSDLPointer { destinationPointer in
                SDL_UpperBlit(internalPointer, sourcePointer, surface.internalPointer, destinationPointer)
            }
        }.sdlThrow(type: "SDLSurface")
    }

    /// Perform a fast fill of the given rectangle with a mapped pixel value.
    public func fill(rect: SDLRect? = nil, color: UInt32) throws(SDLError) {

        try rect.withUnsafeSDLPointer { rectPointer in
            SDL_FillRect(internalPointer, rectPointer, color)
        }.sdlThrow(type: "SDLSurface")
    }

    /// Set the transparent color key for the surface, or `nil` to disable color keying.
    public func setColorKey(_ key: UInt32?) throws(SDLError) {
        let flag = key == nil ? 0 : (UInt32(SDL_SRCCOLORKEY) | UInt32(SDL_RLEACCEL))
        try SDL_SetColorKey(internalPointer, flag, key ?? 0).sdlThrow(type: "SDLSurface")
    }

    /// Set the overall alpha value for the surface, or `nil` to disable alpha blending.
    public func setAlpha(_ alpha: UInt8?) throws(SDLError) {
        let flag = alpha == nil ? 0 : UInt32(SDL_SRCALPHA)
        try SDL_SetAlpha(internalPointer, flag, alpha ?? .max).sdlThrow(type: "SDLSurface")
    }

    /// Set a range of colors in a paletted surface.
    ///
    /// - Returns: `true` if all colors were set exactly as passed.
    @discardableResult
    public func setColors(_ colors: [SDLColor], firstColor: Int = 0) -> Bool {
        var colors = colors.map { $0.internalValue }
        return SDL_SetColors(internalPointer, &colors, CInt(firstColor), CInt(colors.count)) == 1
    }

    /// Return a copy of this surface converted to the display format for fast blitting.
    public func displayFormat(alpha: Bool = false) throws(SDLError) -> SDLSurface {
        let converted = alpha ? SDL_DisplayFormatAlpha(internalPointer) : SDL_DisplayFormat(internalPointer)
        return SDLSurface(internalPointer: try converted.sdlThrow(type: "SDLSurface"))
    }

    /// Save the surface to a BMP file.
    public func saveBMP(to path: String) throws(SDLError) {
        try SDL_SaveBMP_RW(internalPointer, SDL_RWFromFile(path, "wb"), 1).sdlThrow(type: "SDLSurface")
    }
}

// MARK: - Supporting Types

public extension SDLSurface {

    /// Surface and video mode flags.
    enum Flag: UInt32, BitMaskOption {

        /// Surface is stored in video memory.
        case hardwareSurface = 0x00000001
        /// Create an OpenGL rendering context.
        case openGL = 0x00000002
        /// Surface uses asynchronous blits if possible.
        case asyncBlit = 0x00000004
        /// Surface is resizable.
        case resizable = 0x00000010
        /// No window caption or edge frame.
        case noFrame = 0x00000020
        /// Blit uses source color keying.
        case sourceColorKey = 0x00001000
        /// Surface is RLE encoded.
        case rleAccel = 0x00004000
        /// Blit uses source alpha blending.
        case sourceAlpha = 0x00010000
        /// Allow any pixel format for the video surface.
        case anyFormat = 0x10000000
        /// Surface has an exclusive palette.
        case hardwarePalette = 0x20000000
        /// Surface is double buffered.
        case doubleBuffer = 0x40000000
        /// Surface is full screen.
        case fullscreen = 0x80000000
    }
}

// MARK: - Internal Helpers

internal extension Optional where Wrapped == SDLRect {

    /// Call `body` with a pointer to the underlying `SDL_Rect`, or `nil` when absent.
    func withUnsafeSDLPointer<Result>(_ body: (UnsafeMutablePointer<SDL_Rect>?) -> Result) -> Result {
        guard var rect = self?.internalValue else {
            return body(nil)
        }
        return withUnsafeMutablePointer(to: &rect, body)
    }
}
