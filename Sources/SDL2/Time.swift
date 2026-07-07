//
//  Time.swift
//  SDL2
//
//  Created by Alsey Coleman Miller on 7/7/26.
//

import CSDL2

public extension SDL {

    /// The number of milliseconds since SDL library initialization.
    static var ticksMilliseconds: UInt64 {
        SDL_GetTicks64()
    }

    /// Wait the specified number of milliseconds before returning.
    static func delay(milliseconds: UInt32) {
        SDL_Delay(milliseconds)
    }
}
