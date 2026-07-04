//
//  BlendMode.swift
//  SDL3
//
//  Created by Alsey Coleman Miller on 6/8/17.
//

import CSDL3

// An enumeration of blend modes used in `Renderer.copy()` and drawing operations.
public enum SDLBlendMode: UInt32, BitMaskOption {

    /// Alpha blending
    case alpha = 0x00000001

    /// Additive blending
    case additive = 0x00000002

    /// Color modulate
    case modulate = 0x00000004

    /// Color multiply
    case multiply = 0x00000008

    /// Pre-multiplied alpha blending
    case alphaPremultiplied = 0x00000010

    /// Pre-multiplied additive blending
    case additivePremultiplied = 0x00000020
}
