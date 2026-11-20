//
//  CustomBlendMode.swift
//  SDL3
//

import CSDL3

/// A blend mode composed from factors and operations, for what the built-in
/// modes don't cover.
///
/// The color drawn is `source * sourceColorFactor (operation) destination *
/// destinationColorFactor`, and alpha likewise with its own factors. Not
/// every renderer supports every combination: setting an unsupported one
/// fails.
public struct SDLCustomBlendMode: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public init(
        sourceColorFactor: Factor,
        destinationColorFactor: Factor,
        colorOperation: Operation = .add,
        sourceAlphaFactor: Factor,
        destinationAlphaFactor: Factor,
        alphaOperation: Operation = .add
    ) {
        self.rawValue = SDL_ComposeCustomBlendMode(
            sourceColorFactor.internalValue, destinationColorFactor.internalValue, colorOperation.internalValue,
            sourceAlphaFactor.internalValue, destinationAlphaFactor.internalValue, alphaOperation.internalValue
        )
    }

    /// Keeps the destination only where the source is opaque (Porter-Duff
    /// "destination in"), for masking.
    public static var destinationIn: SDLCustomBlendMode {
        SDLCustomBlendMode(
            sourceColorFactor: .zero, destinationColorFactor: .sourceAlpha,
            sourceAlphaFactor: .zero, destinationAlphaFactor: .sourceAlpha
        )
    }
}

public extension SDLCustomBlendMode {

    /// What a pixel's components are multiplied by.
    enum Factor: Equatable, Hashable, Sendable {
        case zero
        case one
        case sourceColor
        case oneMinusSourceColor
        case sourceAlpha
        case oneMinusSourceAlpha
        case destinationColor
        case oneMinusDestinationColor
        case destinationAlpha
        case oneMinusDestinationAlpha

        internal var internalValue: SDL_BlendFactor {
            switch self {
            case .zero: SDL_BLENDFACTOR_ZERO
            case .one: SDL_BLENDFACTOR_ONE
            case .sourceColor: SDL_BLENDFACTOR_SRC_COLOR
            case .oneMinusSourceColor: SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR
            case .sourceAlpha: SDL_BLENDFACTOR_SRC_ALPHA
            case .oneMinusSourceAlpha: SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA
            case .destinationColor: SDL_BLENDFACTOR_DST_COLOR
            case .oneMinusDestinationColor: SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR
            case .destinationAlpha: SDL_BLENDFACTOR_DST_ALPHA
            case .oneMinusDestinationAlpha: SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA
            }
        }
    }

    /// How the multiplied source and destination combine.
    enum Operation: Equatable, Hashable, Sendable {
        /// `destination + source`
        case add
        /// `source - destination`
        case subtract
        /// `destination - source`
        case reverseSubtract
        case minimum
        case maximum

        internal var internalValue: SDL_BlendOperation {
            switch self {
            case .add: SDL_BLENDOPERATION_ADD
            case .subtract: SDL_BLENDOPERATION_SUBTRACT
            case .reverseSubtract: SDL_BLENDOPERATION_REV_SUBTRACT
            case .minimum: SDL_BLENDOPERATION_MINIMUM
            case .maximum: SDL_BLENDOPERATION_MAXIMUM
            }
        }
    }
}

public extension SDLTexture {

    /// Blend the texture with a custom blend mode when it's drawn.
    func setBlendMode(_ mode: SDLCustomBlendMode) throws(SDLError) {
        try SDL_SetTextureBlendMode(internalPointer, SDL_BlendMode(mode.rawValue)).sdlThrow(type: "SDLTexture")
    }
}

public extension SDLRenderer {

    /// Blend fills and lines with a custom blend mode.
    func setDrawBlendMode(_ mode: SDLCustomBlendMode) throws(SDLError) {
        try SDL_SetRenderDrawBlendMode(internalPointer, SDL_BlendMode(mode.rawValue)).sdlThrow(type: "SDLRenderer")
    }
}
