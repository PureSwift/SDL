//
//  Window.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

/// SDL Window
public final class SDLWindow {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        SDL_DestroyWindow(internalPointer)
    }
    
    /// Create a window with the specified position, dimensions, and flags.
    public init(title: String,
                frame: (x: Position, y: Position, width: Int, height: Int),
                options: BitMaskOptionSet<SDLWindow.Option> = []) throws {
        
        let internalPointer = SDL_CreateWindow(title, frame.x.rawValue, frame.y.rawValue, Int32(frame.width), Int32(frame.height), options.rawValue)
        
        self.internalPointer = try internalPointer.sdlThrow(type: type(of: self))
    }
    
    // MARK: - Accessors
    
    /// Get the numeric ID of a window, for logging purposes.
    public var identifier: UInt {
        return UInt(SDL_GetWindowID(internalPointer))
    }
    
    /// Fill in information about the display mode used when a fullscreen window is visible.
    public func displayMode() throws -> SDLDisplayMode {
        
        var sdlDisplayMode = SDL_DisplayMode()
        try SDL_GetWindowDisplayMode(internalPointer, &sdlDisplayMode).sdlThrow(type: type(of: self))
        return SDLDisplayMode(sdlDisplayMode)
    }
    
    /// Use this function to get the size of a window's client area (in points).
    public var size: (width: Int, height: Int) {
        
        get {
            
            var width: Int32 = 0
            var height: Int32 = 0
            SDL_GetWindowSize(internalPointer, &width, &height)
            
            return (Int(width), Int(height))
        }
        
        set { SDL_SetWindowSize(internalPointer, Int32(size.width), Int32(size.height)) }
    }
    
    /// Size of a window's underlying drawable in pixels (for use with glViewport).
    ///
    /// This may differ from `size` if we're rendering to a high-DPI drawable,
    /// i.e. the window was created with `.allowRetina` on a platform with Retina support.
    public var drawableSize: (width: Int, height: Int) {
        
        var width: Int32 = 0
        var height: Int32 = 0
        SDL_GL_GetDrawableSize(internalPointer, &width, &height)
        
        return (Int(width), Int(height))
    }
    
    /// Raise a window above other windows and set the input focus
    public func raise() {
        
        SDL_RaiseWindow(internalPointer)
    }
    
    /// The output size in pixels of a rendering context.
    public var rendererSize: (width: Int, height: Int)? {
        
        var width: Int32 = 0
        var height: Int32 = 0
        guard SDL_GetRendererOutputSize(internalPointer, &width, &height) >= 0
            else { return nil }
        
        return (Int(width), Int(height))
    }
    
    // MARK: - Methods
    
    /// Copy the window surface to the screen.
    public func updateSurface() throws {
        
        try SDL_UpdateWindowSurface(internalPointer).sdlThrow(type: type(of: self))
    }
    
    /// Set the display mode to use when a window is visible at fullscreen.
    public func setDisplayMode(_ newValue: SDL_DisplayMode?) -> Bool {
        
        if var newValue = newValue {
            
            return SDL_SetWindowDisplayMode(internalPointer, &newValue) >= 0
            
        } else {
            
            return SDL_SetWindowDisplayMode(internalPointer, nil) >= 0
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

private var SDL_WINDOWPOS_UNDEFINED: CInt { return 0x1FFF0000 }
private var SDL_WINDOWPOS_CENTERED: CInt { return 0x2FFF0000 }

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
    enum Option: UInt32, BitMaskOption {
        
        /// fullscreen window
        case fullscreen = 0x00000001
        
        /// fullscreen window at the current desktop resolution
        case fullscreenDesktop = 0x00001001 // ( SDL_WINDOW_FULLSCREEN | 0x00001000 )
        
        /// window usable with opengl context
        case opengl = 0x00000002
        
        /// window is visible
        case shown = 0x00000004
        
        /// window is not visible
        case hidden = 0x00000008
        
        /// no window decoration
        case borderless = 0x00000010
        
        /// window can be resized
        case resizable = 0x00000020
        
        /// window is minimized
        case minimized = 0x00000040
        
        /// window is maximized
        case maximized = 0x00000080
        
        /// window has grabbed input focus
        case inputGrabbed = 0x00000100
        /// window has input focus
        case inputFocus = 0x00000200
        
        /// window has mouse focus
        case mouseFocus = 0x00000400
        
        /// window not created by sdl
        case foreign = 0x00000800
        
        /// window should be created in retina / high-dpi mode if supported (>= sdl 2.0.1)
        case allowRetina = 0x00002000
        
        /// window has mouse captured (unrelated to input_grabbed, >= sdl 2.0.4)
        case mouseCapture = 0x00004000
        
        /// window should always be above others (x11 only, >= sdl 2.0.5)
        case alwaysOnTop = 0x00008000
        
        /// window should not be added to the taskbar (x11 only, >= sdl 2.0.5)
        case skipTaskbar = 0x00010000
        
        /// window should be treated as a utility window (x11 only, >= sdl 2.0.5)
        case utility = 0x00020000
        
        /// window should be treated as a tooltip (x11 only, >= sdl 2.0.5)
        case tooltip = 0x00040000
        
        // window should be treated as a popup menu (x11 only, >= sdl 2.0.5)
        case popupMenu = 0x00080000
    }
}
