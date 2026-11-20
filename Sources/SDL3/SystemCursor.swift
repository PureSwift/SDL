//
//  SystemCursor.swift
//  SDL3
//

import CSDL3

public extension SDLCursor {

    /// The cursors the system provides.
    enum System: Equatable, Hashable, Sendable, CaseIterable {

        /// The default cursor: usually an arrow.
        case `default`

        /// Text selection: usually an I-beam.
        case text

        /// Wait: usually an hourglass, a watch or a spinning ball.
        case wait

        case crosshair

        /// The program is busy but still interactive.
        case progress

        /// A double arrow pointing northwest and southeast.
        case northwestSoutheastResize

        /// A double arrow pointing northeast and southwest.
        case northeastSouthwestResize

        /// A double arrow pointing west and east.
        case eastWestResize

        /// A double arrow pointing north and south.
        case northSouthResize

        /// Four arrows, pointing north, south, east and west.
        case move

        /// Not permitted: usually a slashed circle or crossbones.
        case notAllowed

        /// What a link shows: usually a pointing hand.
        case pointer

        internal var internalValue: SDL_SystemCursor {
            switch self {
            case .default: SDL_SYSTEM_CURSOR_DEFAULT
            case .text: SDL_SYSTEM_CURSOR_TEXT
            case .wait: SDL_SYSTEM_CURSOR_WAIT
            case .crosshair: SDL_SYSTEM_CURSOR_CROSSHAIR
            case .progress: SDL_SYSTEM_CURSOR_PROGRESS
            case .northwestSoutheastResize: SDL_SYSTEM_CURSOR_NWSE_RESIZE
            case .northeastSouthwestResize: SDL_SYSTEM_CURSOR_NESW_RESIZE
            case .eastWestResize: SDL_SYSTEM_CURSOR_EW_RESIZE
            case .northSouthResize: SDL_SYSTEM_CURSOR_NS_RESIZE
            case .move: SDL_SYSTEM_CURSOR_MOVE
            case .notAllowed: SDL_SYSTEM_CURSOR_NOT_ALLOWED
            case .pointer: SDL_SYSTEM_CURSOR_POINTER
            }
        }
    }

    /// Create one of the system's cursors.
    convenience init(system cursor: System) throws(SDLError) {
        let pointer = try SDL_CreateSystemCursor(cursor.internalValue).sdlThrow(type: "SDLCursor")
        self.init(pointer, isOwner: true)
    }
}
