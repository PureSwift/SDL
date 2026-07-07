//
//  Time.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL3

public extension SDL {

    /// The number of milliseconds since SDL library initialization.
    static var ticksMilliseconds: UInt64 {
        SDL_GetTicks()
    }

    /// Wait the specified number of milliseconds before returning.
    static func delay(milliseconds: UInt32) {
        SDL_Delay(milliseconds)
    }

    /// The current value of the system clock in nanoseconds since a platform-specific epoch.
    static var currentTime: SDLDateTime? {

        var ticks: SDL_Time = 0
        guard SDL_GetCurrentTime(&ticks) else { return nil }
        var dateTime = SDL_DateTime()
        guard SDL_TimeToDateTime(ticks, &dateTime, true) else { return nil }
        return SDLDateTime(dateTime)
    }
}

// MARK: - Supporting Types

/// A calendar date and time broken down into its components.
public struct SDLDateTime: Equatable, Hashable, Sendable {

    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var nanosecond: Int
    public var dayOfWeek: Int
    public var utcOffset: Int

    internal init(_ internalValue: SDL_DateTime) {
        self.year = Int(internalValue.year)
        self.month = Int(internalValue.month)
        self.day = Int(internalValue.day)
        self.hour = Int(internalValue.hour)
        self.minute = Int(internalValue.minute)
        self.second = Int(internalValue.second)
        self.nanosecond = Int(internalValue.nanosecond)
        self.dayOfWeek = Int(internalValue.day_of_week)
        self.utcOffset = Int(internalValue.utc_offset)
    }
}
