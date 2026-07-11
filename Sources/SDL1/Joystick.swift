//
//  Joystick.swift
//  SDL1
//
//  Created by Alsey Coleman Miller on 7/10/26.
//

import CSDL

/// SDL Joystick
public final class SDLJoystick {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        SDL_JoystickClose(internalPointer)
    }

    /// Open a joystick for use by its device index.
    public init(index: Int) throws(SDLError) {
        let internalPointer = SDL_JoystickOpen(CInt(index))
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLJoystick")
    }

    // MARK: - Static Accessors

    /// The number of joysticks attached to the system.
    public static var count: Int {
        return Int(SDL_NumJoysticks())
    }

    /// The implementation-dependent name of the joystick at the given device index.
    public static func name(for index: Int) -> String? {
        guard let cString = SDL_JoystickName(CInt(index)) else { return nil }
        return String(cString: cString)
    }

    /// Update the state of all open joysticks.
    ///
    /// Not needed if joystick events are enabled.
    public static func update() {
        SDL_JoystickUpdate()
    }

    /// Enable or disable joystick event polling.
    @discardableResult
    public static func setEventState(_ enabled: Bool) -> Bool {
        return SDL_JoystickEventState(enabled ? 1 : 0) == 1
    }

    // MARK: - Accessors

    /// The device index of this joystick.
    public var index: Int {
        return Int(SDL_JoystickIndex(internalPointer))
    }

    /// The number of general axis controls on the joystick.
    public var numberOfAxes: Int {
        return Int(SDL_JoystickNumAxes(internalPointer))
    }

    /// The number of trackballs on the joystick.
    public var numberOfBalls: Int {
        return Int(SDL_JoystickNumBalls(internalPointer))
    }

    /// The number of POV hats on the joystick.
    public var numberOfHats: Int {
        return Int(SDL_JoystickNumHats(internalPointer))
    }

    /// The number of buttons on the joystick.
    public var numberOfButtons: Int {
        return Int(SDL_JoystickNumButtons(internalPointer))
    }

    // MARK: - Methods

    /// The current value of the given axis, in the range `-32768` to `32767`.
    public func axis(_ axis: Int) -> Int16 {
        return SDL_JoystickGetAxis(internalPointer, CInt(axis))
    }

    /// Whether the given button is currently pressed.
    public func button(_ button: Int) -> Bool {
        return SDL_JoystickGetButton(internalPointer, CInt(button)) != 0
    }

    /// The current position of the given POV hat.
    public func hat(_ hat: Int) -> UInt8 {
        return SDL_JoystickGetHat(internalPointer, CInt(hat))
    }

    /// The relative movement of the given trackball since the last query.
    public func ball(_ ball: Int) -> (dx: Int, dy: Int)? {
        var dx: CInt = 0
        var dy: CInt = 0
        guard SDL_JoystickGetBall(internalPointer, CInt(ball), &dx, &dy) == 0 else { return nil }
        return (Int(dx), Int(dy))
    }
}
