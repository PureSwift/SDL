//
//  UserEvent.swift
//  SDL3
//

import CSDL3

public extension SDL {

    /// Reserves event types for the app's own events.
    ///
    /// - Parameter count: How many consecutive types to reserve.
    /// - Returns: The first of the types, or `nil` if there aren't that
    ///   many left.
    static func registerEvents(count: Int = 1) -> UInt32? {
        let type = SDL_RegisterEvents(Int32(count))
        return type == 0 ? nil : type
    }

    /// Adds one of the app's own events to the queue, which `pollEvent`
    /// and `waitEvent` return as `SDLEvent.user`.
    ///
    /// This can be called from any thread: it's how another thread wakes a
    /// loop that's waiting for events.
    ///
    /// - Parameter type: A type from `registerEvents`.
    /// - Returns: Whether the event was queued; an event filter may drop it.
    @discardableResult
    static func pushUserEvent(type: UInt32, windowID: UInt32 = 0, code: Int32 = 0) -> Bool {
        var event = SDL_Event()
        event.user.type = type
        event.user.windowID = windowID
        event.user.code = code
        return SDL_PushEvent(&event)
    }
}
