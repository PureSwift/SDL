//
//  MessageBox.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3
#if canImport(Glibc)
import Glibc
#else
import Darwin
#endif

public extension SDL {

    /// Display a simple modal message box.
    static func showSimpleMessageBox(flags: MessageBoxFlags, title: String, message: String, window: SDLWindow? = nil) throws(SDLError) {

        try SDL_ShowSimpleMessageBox(flags.rawValue, title, message, window?.internalPointer).sdlThrow(type: "SDL")
    }

    /// Display a modal message box with buttons, and answer the index of the one chosen,
    /// or `nil` when the box was closed without a choice.
    ///
    /// The first button is the one Return chooses; `escapeIndex` names the one Escape chooses.
    static func showMessageBox(flags: MessageBoxFlags, title: String, message: String, buttons: [String], escapeIndex: Int? = nil, window: SDLWindow? = nil) throws(SDLError) -> Int? {

        let texts = buttons.map { strdup($0) }
        defer { texts.forEach { free($0) } }
        let data = texts.enumerated().map { index, text in
            SDL_MessageBoxButtonData(flags: (index == 0 ? SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT : 0) | (index == escapeIndex ? SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT : 0),
                                     buttonID: Int32(index), text: UnsafePointer(text))
        }
        var chosen: Int32 = -1
        let shown: Bool = title.withCString { title in
            message.withCString { message in
                data.withUnsafeBufferPointer { buttons in
                    var box = SDL_MessageBoxData(flags: flags.rawValue | SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT, window: window?.internalPointer,
                                                 title: title, message: message, numbuttons: Int32(buttons.count),
                                                 buttons: buttons.baseAddress, colorScheme: nil)
                    return SDL_ShowMessageBox(&box, &chosen)
                }
            }
        }
        try shown.sdlThrow(type: "SDL")
        return chosen >= 0 ? Int(chosen) : nil
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
