//
//  Cursor.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Cursor
public final class SDLCursor {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<SDL_Cursor>

    internal let owned: Bool

    // MARK: - Initialization

    deinit {
        if owned {
            SDL_FreeCursor(internalPointer)
        }
    }

    internal init(internalPointer: UnsafeMutablePointer<SDL_Cursor>, owned: Bool) {
        self.internalPointer = internalPointer
        self.owned = owned
    }

    /// Create a cursor from monochrome data and mask bitmaps.
    ///
    /// - Parameters:
    ///   - data: The cursor bitmap; each bit is a pixel (1 = black, 0 = white when the mask bit is set).
    ///   - mask: The transparency mask; each bit set marks the pixel as opaque.
    ///   - size: The width and height of the cursor in pixels. Width must be a multiple of 8.
    ///   - hotspot: The position of the cursor hotspot, relative to the top-left.
    public init(
        data: [UInt8],
        mask: [UInt8],
        size: (width: Int, height: Int),
        hotspot: (x: Int, y: Int)
    ) throws(SDLError) {

        var data = data
        var mask = mask
        let internalPointer = SDL_CreateCursor(&data, &mask, CInt(size.width), CInt(size.height), CInt(hotspot.x), CInt(hotspot.y))
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLCursor")
        self.owned = true
    }

    // MARK: - Accessors

    /// The currently active cursor.
    public static var current: SDLCursor? {
        guard let internalPointer = SDL_GetCursor() else { return nil }
        return SDLCursor(internalPointer: internalPointer, owned: false)
    }

    // MARK: - Methods

    /// Set this cursor as the active cursor.
    public func set() {
        SDL_SetCursor(internalPointer)
    }
}
