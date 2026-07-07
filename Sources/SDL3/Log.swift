//
//  Log.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

public extension SDL {

    /// Log a message with the given category and priority.
    ///
    /// - Note: SDL's variadic logging functions (`SDL_Log`, `SDL_LogError`, ...) aren't callable
    ///   from Swift, so this routes through `SDL_LogMessageV` with a fixed `"%s"` format string.
    static func log(_ message: String, category: LogCategory = .application, priority: LogPriority = .info) {

        message.withCString { cString in
            withVaList([cString]) { arguments in
                SDL_LogMessageV(category.rawValue, priority.sdlValue, "%s", arguments)
            }
        }
    }

    /// Set the priority of all log categories.
    static func setLogPriorities(_ priority: LogPriority) {
        SDL_SetLogPriorities(priority.sdlValue)
    }
}

// MARK: - Supporting Types

/// A category of a log message.
public struct LogCategory: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: Int32

    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public static var application: LogCategory { LogCategory(rawValue: Int32(SDL_LOG_CATEGORY_APPLICATION.rawValue)) }
}

/// The priority of a log message.
public struct LogPriority: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    internal var sdlValue: SDL_LogPriority {
        SDL_LogPriority(rawValue: rawValue)
    }

    public static var verbose: LogPriority { LogPriority(rawValue: SDL_LOG_PRIORITY_VERBOSE.rawValue) }
    public static var info: LogPriority { LogPriority(rawValue: SDL_LOG_PRIORITY_INFO.rawValue) }
    public static var warn: LogPriority { LogPriority(rawValue: SDL_LOG_PRIORITY_WARN.rawValue) }
    public static var error: LogPriority { LogPriority(rawValue: SDL_LOG_PRIORITY_ERROR.rawValue) }
    public static var critical: LogPriority { LogPriority(rawValue: SDL_LOG_PRIORITY_CRITICAL.rawValue) }
}
