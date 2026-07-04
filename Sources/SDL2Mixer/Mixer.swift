//
//  Mixer.swift
//  SDL2Mixer
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import SDL2Swift
import CSDL2Mixer

public extension SDL {

    /// Initialize `SDL_mixer` for the given audio file formats.
    static func initializeMixer(formats: BitMaskOptionSet<SDLMixerFormat>) throws(SDLError) {

        let flags = formats.rawValue
        guard Mix_Init(flags) & flags == flags else {
            let context = SDLError.Context(file: #file, type: "SDL", function: #function, line: #line)
            throw SDLError.current(context: context) ?? SDLError(errorMessage: "Mix_Init failed", context: context)
        }
    }

    /// Shut down and clean up `SDL_mixer`.
    static func quitMixer() {
        Mix_Quit()
    }

    /// Open the default audio device for playback with `SDL_mixer`.
    static func openAudio(frequency: Int32 = 44100, format: UInt16 = UInt16(AUDIO_S16LSB), channels: Int32 = 2, chunkSize: Int32 = 2048) throws(SDLError) {

        try Mix_OpenAudio(frequency, format, channels, chunkSize).sdlThrow(type: "SDL")
    }

    /// Close the audio device opened with `openAudio(frequency:format:channels:chunkSize:)`.
    static func closeAudio() {
        Mix_CloseAudio()
    }
}

/// Audio file formats that can be requested when initializing `SDL_mixer`.
public enum SDLMixerFormat: Int32, BitMaskOption {

    case flac = 0x00000001
    case mod = 0x00000002
    case mp3 = 0x00000008
    case ogg = 0x00000010
    case mid = 0x00000020
    case opus = 0x00000040
    case wavpack = 0x00000080
}

/// A pre-decoded, short audio sample (`Mix_Chunk`) played on an automatically-selected channel.
public final class SDLAudioChunk {

    // MARK: - Properties

    internal let internalPointer: UnsafeMutablePointer<Mix_Chunk>

    // MARK: - Initialization

    deinit {
        Mix_FreeChunk(internalPointer)
    }

    /// Load a WAV, OGG, or other supported audio file as a chunk.
    public init(contentsOfFile path: String) throws(SDLError) {

        let internalPointer = Mix_LoadWAV(path)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLAudioChunk")
    }

    // MARK: - Methods

    /// Play the chunk on the first free channel.
    ///
    /// - Parameter loops: The number of times to loop, or `-1` to loop forever.
    /// - Returns: The channel the chunk is playing on.
    @discardableResult
    public func play(loops: Int32 = 0) throws(SDLError) -> Int32 {
        let channel = Mix_PlayChannel(-1, internalPointer, loops)
        try channel.sdlThrow(type: "SDLAudioChunk")
        return channel
    }
}

/// A single streamed music track (`Mix_Music`).
public final class SDLMusic {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    // MARK: - Initialization

    deinit {
        Mix_FreeMusic(internalPointer)
    }

    /// Load a music file for streamed playback.
    public init(contentsOfFile path: String) throws(SDLError) {

        let internalPointer = Mix_LoadMUS(path)
        self.internalPointer = try internalPointer.sdlThrow(type: "SDLMusic")
    }

    // MARK: - Accessors

    /// Whether music is actively playing.
    public static var isPlaying: Bool {
        Mix_PlayingMusic() != 0
    }

    // MARK: - Methods

    /// Play the music.
    ///
    /// - Parameter loops: The number of times to loop, or `-1` to loop forever.
    public func play(loops: Int32 = -1) throws(SDLError) {
        try Mix_PlayMusic(internalPointer, loops).sdlThrow(type: "SDLMusic")
    }

    /// Stop the currently playing music.
    public static func halt() throws(SDLError) {
        try Mix_HaltMusic().sdlThrow(type: "SDLMusic")
    }
}
