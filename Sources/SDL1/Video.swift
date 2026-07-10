//
//  Video.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

public extension SDL {

    /// Set up a video mode with the specified width, height and bits-per-pixel.
    ///
    /// - Returns: The screen surface. This surface is owned by SDL and is freed by `SDL.quit()`.
    @discardableResult
    static func setVideoMode(
        width: Int,
        height: Int,
        bitsPerPixel: Int = 0,
        flags: BitMaskOptionSet<SDLSurface.Flag> = []
    ) throws(SDLError) -> SDLSurface {

        let internalPointer = SDL_SetVideoMode(CInt(width), CInt(height), CInt(bitsPerPixel), flags.rawValue)
        return SDLSurface(internalPointer: try internalPointer.sdlThrow(type: "SDLSurface"), owned: false)
    }

    /// The current display surface, if a video mode has been set.
    static var videoSurface: SDLSurface? {
        guard let internalPointer = SDL_GetVideoSurface() else { return nil }
        return SDLSurface(internalPointer: internalPointer, owned: false)
    }

    /// Check whether a video mode is supported.
    ///
    /// - Returns: `0` if the mode is not supported, otherwise the bits-per-pixel of the closest match.
    static func videoModeSupported(
        width: Int,
        height: Int,
        bitsPerPixel: Int,
        flags: BitMaskOptionSet<SDLSurface.Flag> = []
    ) -> Int {
        return Int(SDL_VideoModeOK(CInt(width), CInt(height), CInt(bitsPerPixel), flags.rawValue))
    }

    /// Swap the screen buffers, updating the display.
    static func flip(_ screen: SDLSurface) throws(SDLError) {
        try SDL_Flip(screen.internalPointer).sdlThrow(type: "SDLSurface")
    }

    /// Make sure the given area of the screen is updated.
    ///
    /// Passing a `nil` rectangle updates the entire screen.
    static func update(_ screen: SDLSurface, rect: SDLRect? = nil) {
        if let rect {
            SDL_UpdateRect(screen.internalPointer, Int32(rect.x), Int32(rect.y), UInt32(rect.width), UInt32(rect.height))
        } else {
            SDL_UpdateRect(screen.internalPointer, 0, 0, 0, 0)
        }
    }

    /// Make sure the given list of areas of the screen are updated.
    static func update(_ screen: SDLSurface, rects: [SDLRect]) {
        var rects = rects.map { $0.internalValue }
        SDL_UpdateRects(screen.internalPointer, CInt(rects.count), &rects)
    }

    /// Set the title and icon text of the display window.
    static func setCaption(title: String, icon: String? = nil) {
        SDL_WM_SetCaption(title, icon ?? title)
    }

    /// Set the icon for the display window.
    static func setIcon(_ surface: SDLSurface) {
        SDL_WM_SetIcon(surface.internalPointer, nil)
    }

    /// Iconify (minimize) the display window.
    @discardableResult
    static func iconifyWindow() -> Bool {
        return SDL_WM_IconifyWindow() != 0
    }

    /// Toggle between full screen and windowed mode.
    @discardableResult
    static func toggleFullScreen(_ screen: SDLSurface) -> Bool {
        return SDL_WM_ToggleFullScreen(screen.internalPointer) != 0
    }
}

// MARK: - Supporting Types

public extension SDL {

    /// Information about the video hardware.
    struct VideoInfo {

        internal let internalValue: SDL_VideoInfo

        /// Get information about the video hardware.
        public init() {
            self.internalValue = SDL_GetVideoInfo().pointee
        }

        /// Whether it is possible to create hardware surfaces.
        public var hardwareAvailable: Bool {
            return internalValue.hw_available != 0
        }

        /// Whether a window manager is available.
        public var windowManagerAvailable: Bool {
            return internalValue.wm_available != 0
        }

        /// The total amount of video memory, in kilobytes.
        public var videoMemory: Int {
            return Int(internalValue.video_mem)
        }

        /// The width of the current video mode, in pixels.
        public var currentWidth: Int {
            return Int(internalValue.current_w)
        }

        /// The height of the current video mode, in pixels.
        public var currentHeight: Int {
            return Int(internalValue.current_h)
        }
    }
}
