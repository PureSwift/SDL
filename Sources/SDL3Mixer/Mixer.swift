//
//  Mixer.swift
//  SDL3Mixer
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import SDL3Swift
import CSDL3Mixer

public extension SDL {

    /// Initialize `SDL_mixer`.
    static func initializeMixer() throws(SDLError) {
        try MIX_Init().sdlThrow(type: "SDL")
    }

    /// Shut down and clean up `SDL_mixer`.
    static func quitMixer() {
        MIX_Quit()
    }
}

/// An audio mixer device (`MIX_Mixer`), shared by every `SDLAudioTrack` and one-shot
/// `SDLAudio.play(on:)` call.
public final class SDLMixer {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        MIX_DestroyMixer(internalPointer)
    }

    /// Open an audio device for mixed playback.
    public init(device: AudioDeviceID = SDL.defaultPlaybackAudioDevice) throws(SDLError) {

        let internalPointer = MIX_CreateMixerDevice(device.rawValue, nil)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLMixer")
    }

    // MARK: - Methods

    /// Play a loaded audio sample once, on an automatically-managed track.
    public func play(_ audio: SDLAudio) throws(SDLError) {
        try MIX_PlayAudio(internalPointer, audio.internalPointer).sdlThrow(type: "SDLMixer")
    }
}

/// A loaded (and optionally pre-decoded) audio asset (`MIX_Audio`) - a sound effect or music
/// track ready to be played via `SDLMixer.play(_:)` or assigned to an `SDLAudioTrack`.
public final class SDLAudio {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        MIX_DestroyAudio(internalPointer)
    }

    /// Load an audio file (WAV, OGG, and other formats bundled with `SDL_mixer`).
    ///
    /// - Parameter predecode: Decode the entire file up front instead of streaming it,
    ///   trading memory for lower per-play latency. Appropriate for short sound effects,
    ///   not for music.
    public init(mixer: SDLMixer, contentsOfFile path: String, predecode: Bool = false) throws(SDLError) {

        let internalPointer = MIX_LoadAudio(mixer.internalPointer, path, predecode)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLAudio")
    }
}

/// A single playback slot (`MIX_Track`) that an `SDLAudio` can be assigned to and played on,
/// used here for the one music track that streams at a time.
public final class SDLAudioTrack {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        MIX_DestroyTrack(internalPointer)
    }

    /// Create a new track on the given mixer.
    public init(mixer: SDLMixer) throws(SDLError) {

        let internalPointer = MIX_CreateTrack(mixer.internalPointer)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLAudioTrack")
    }

    // MARK: - Accessors

    /// Whether the track is currently playing.
    public var isPlaying: Bool {
        MIX_TrackPlaying(internalPointer)
    }

    // MARK: - Methods

    /// Assign the audio to be played on this track.
    public func setAudio(_ audio: SDLAudio) throws(SDLError) {
        try MIX_SetTrackAudio(internalPointer, audio.internalPointer).sdlThrow(type: "SDLAudioTrack")
    }

    /// Play the track's currently assigned audio.
    public func play() throws(SDLError) {
        try MIX_PlayTrack(internalPointer, 0).sdlThrow(type: "SDLAudioTrack")
    }

    /// Stop playback on this track.
    ///
    /// - Parameter fadeOutFrames: The number of sample frames to fade out over, or `0` to stop immediately.
    public func stop(fadeOutFrames: Int64 = 0) throws(SDLError) {
        try MIX_StopTrack(internalPointer, fadeOutFrames).sdlThrow(type: "SDLAudioTrack")
    }
}
