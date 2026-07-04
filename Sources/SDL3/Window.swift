//
//  Window.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL3

/// SDL Window
public final class SDLWindow: Identifiable {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        SDL_DestroyWindow(internalPointer)
    }

    /// Create a window with the specified position, dimensions, and flags.
    public init(title: String,
                frame: (x: Position, y: Position, width: Int, height: Int),
                options: BitMaskOptionSet<SDLWindow.Option> = []) throws(SDLError) {

        let internalPointer = SDL_CreateWindow(title, Int32(frame.width), Int32(frame.height), options.rawValue)

        self.internalPointer = try internalPointer.sdlThrow(type: "SDLWindow")

        SDL_SetWindowPosition(internalPointer, frame.x.rawValue, frame.y.rawValue)
    }

    // MARK: - Accessors

    /// Get the numeric ID of a window, for logging purposes.
    public var id: UInt {
        return UInt(SDL_GetWindowID(internalPointer))
    }

    /// Fill in information about the current display mode used by the window's display.
    public func displayMode() throws(SDLError) -> SDLDisplayMode {

        let displayID = SDL_GetDisplayForWindow(internalPointer)
        let pointer = try SDL_GetCurrentDisplayMode(displayID).sdlThrow(type: "SDLWindow")
        return SDLDisplayMode(pointer.pointee)
    }

    /// Use this function to get the size of a window's client area (in points).
    public var size: (width: Int, height: Int) {

        get {

            var width: Int32 = 0
            var height: Int32 = 0
            SDL_GetWindowSize(internalPointer, &width, &height)

            return (Int(width), Int(height))
        }

        set { SDL_SetWindowSize(internalPointer, Int32(newValue.width), Int32(newValue.height)) }
    }

    /// Size of a window's underlying drawable in pixels (for use with a rendering context).
    ///
    /// This may differ from `size` if we're rendering to a high-DPI drawable,
    /// i.e. the window was created with `.highPixelDensity` on a platform with support for it.
    public var drawableSize: (width: Int, height: Int) {

        var width: Int32 = 0
        var height: Int32 = 0
        SDL_GetWindowSizeInPixels(internalPointer, &width, &height)

        return (Int(width), Int(height))
    }

    /// Raise a window above other windows and set the input focus
    public func raise() {

        SDL_RaiseWindow(internalPointer)
    }

    /// Move the mouse cursor to the given position within the window.
    public func warpMouse(to point: (x: Float, y: Float)) {

        SDL_WarpMouseInWindow(internalPointer, point.x, point.y)
    }

    /// Set the minimum size of the window's client area.
    public func setMinimumSize(width: Int32, height: Int32) {

        SDL_SetWindowMinimumSize(internalPointer, width, height)
    }

    // MARK: - Methods

    /// Copy the window surface to the screen.
    public func updateSurface() throws(SDLError) {

        try SDL_UpdateWindowSurface(internalPointer).sdlThrow(type: "SDLWindow")
    }

    /// Set the display mode to use when a window is visible at fullscreen.
    ///
    /// - Note: Passing `nil` uses the borderless fullscreen desktop mode.
    public func setDisplayMode(_ newValue: SDL_DisplayMode?) -> Bool {

        if var newValue = newValue {

            return SDL_SetWindowFullscreenMode(internalPointer, &newValue)

        } else {

            return SDL_SetWindowFullscreenMode(internalPointer, nil)
        }
    }

    /// Set the title of a window
    public var title: String {

        get {

            return String(cString: SDL_GetWindowTitle(internalPointer))

        }
        set {

            SDL_SetWindowTitle(internalPointer, newValue)

        }
    }
}

// MARK: - Supporting Types

internal var SDL_WINDOWPOS_UNDEFINED: CInt { return 0x1FFF0000 }
internal var SDL_WINDOWPOS_CENTERED: CInt { return 0x2FFF0000 }

public extension SDLWindow {

    enum Position: RawRepresentable {

        case undefined
        case centered
        case point(Int)

        public init?(rawValue: CInt) {

            switch rawValue {
            case SDL_WINDOWPOS_UNDEFINED: self = .undefined
            case SDL_WINDOWPOS_CENTERED: self = .centered
            default: self = .point(Int(rawValue))
            }
        }

        public var rawValue: CInt {

            switch self {
            case .undefined: return SDL_WINDOWPOS_UNDEFINED
            case .centered: return SDL_WINDOWPOS_CENTERED
            case let .point(point): return CInt(point)
            }
        }
    }
}

public extension SDLWindow {

    /// The flags on a window.
    enum Option: UInt64, BitMaskOption {

        /// window is in fullscreen mode
        case fullscreen = 0x0000000000000001

        /// window usable with OpenGL context
        case opengl = 0x0000000000000002

        /// window is occluded
        case occluded = 0x0000000000000004

        /// window is neither mapped onto the desktop nor shown in the taskbar/dock/window list
        case hidden = 0x0000000000000008

        /// no window decoration
        case borderless = 0x0000000000000010

        /// window can be resized
        case resizable = 0x0000000000000020

        /// window is minimized
        case minimized = 0x0000000000000040

        /// window is maximized
        case maximized = 0x0000000000000080

        /// window has grabbed mouse input
        case mouseGrabbed = 0x0000000000000100

        /// window has input focus
        case inputFocus = 0x0000000000000200

        /// window has mouse focus
        case mouseFocus = 0x0000000000000400

        /// window not created by SDL
        case external = 0x0000000000000800

        /// window is modal
        case modal = 0x0000000000001000

        /// window uses high pixel density back buffer if possible
        case highPixelDensity = 0x0000000000002000

        /// window has mouse captured (unrelated to `mouseGrabbed`)
        case mouseCapture = 0x0000000000004000

        /// window has relative mode enabled
        case mouseRelativeMode = 0x0000000000008000

        /// window should always be above others
        case alwaysOnTop = 0x0000000000010000

        /// window should be treated as a utility window, not showing in the task bar and window list
        case utility = 0x0000000000020000

        /// window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
        case tooltip = 0x0000000000040000

        /// window should be treated as a popup menu, requires a parent window
        case popupMenu = 0x0000000000080000

        /// window has grabbed keyboard input
        case keyboardGrabbed = 0x0000000000100000

        /// window usable for Vulkan surface
        case vulkan = 0x0000000010000000

        /// window usable for Metal view
        case metal = 0x0000000020000000

        /// window with transparent buffer
        case transparent = 0x0000000040000000

        /// window should not be focusable
        case notFocusable = 0x0000000080000000
    }
}
