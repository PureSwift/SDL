//
//  Cursor.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

/// SDL Cursor
public final class SDLCursor {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    internal let isOwner: Bool

    // MARK: - Initialization

    deinit {
        if isOwner {
            SDL_DestroyCursor(internalPointer)
        }
    }

    internal init(_ internalPointer: OpaquePointer, isOwner: Bool = true) {
        self.internalPointer = internalPointer
        self.isOwner = isOwner
    }

    /// Create a color cursor from a surface.
    public init(surface: SDLSurface, hotspot: (x: Int, y: Int)) throws(SDLError) {

        let internalPointer = SDL_CreateColorCursor(surface.internalPointer, Int32(hotspot.x), Int32(hotspot.y))
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLCursor")
        self.isOwner = true
    }

    // MARK: - Accessors

    /// The default cursor.
    ///
    /// - Note: This cursor is owned by SDL and should not be destroyed.
    public static var `default`: SDLCursor {
        // force unwrap: guaranteed non-null by SDL, always available
        SDLCursor(SDL_GetDefaultCursor()!, isOwner: false)
    }
}

// MARK: - SDL

public extension SDL {

    /// Set the active cursor.
    ///
    /// - Parameter cursor: The cursor to show, or `nil` to restore the default cursor.
    static func setCursor(_ cursor: SDLCursor?) {
        SDL_SetCursor(cursor?.internalPointer ?? SDL_GetDefaultCursor())
    }

    /// Whether the cursor is currently shown.
    static var isCursorVisible: Bool {
        get { SDL_CursorVisible() }
        set {
            if newValue {
                SDL_ShowCursor()
            } else {
                SDL_HideCursor()
            }
        }
    }
}
