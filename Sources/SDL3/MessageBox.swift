//
//  MessageBox.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

public extension SDL {

    /// Display a simple modal message box.
    static func showSimpleMessageBox(flags: MessageBoxFlags, title: String, message: String, window: SDLWindow? = nil) throws(SDLError) {

        try SDL_ShowSimpleMessageBox(flags.rawValue, title, message, window?.internalPointer).sdlThrow(type: "SDL")
    }
}

// MARK: - Supporting Types

/// Flags for `SDL.showSimpleMessageBox(flags:title:message:window:)`.
public struct MessageBoxFlags: OptionSet, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static var error: MessageBoxFlags { MessageBoxFlags(rawValue: 0x00000010) }
    public static var warning: MessageBoxFlags { MessageBoxFlags(rawValue: 0x00000020) }
    public static var information: MessageBoxFlags { MessageBoxFlags(rawValue: 0x00000040) }
}
