//
//  BitMaskOption.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

/// Enum represents a bit mask flag / option.
public protocol BitMaskOption: RawRepresentable, Hashable where RawValue: FixedWidthInteger {
    
    /// All the cases of the enum.
    static var all: Set<Self> { get }
}

/// Convert Swift enums for option flags into their raw values OR'd.
internal extension Collection where Element: BitMaskOption {
    
    var flags: Element.RawValue {
        
        @inline(__always)
        get { return reduce(0, { $0 | $1.rawValue }) }
    }
}

internal extension BitMaskOption {
    
    /// Whether the enum case is present in the raw value.
    @inline(__always)
    func isContained(in rawValue: RawValue) -> Bool {
        
        return (self.rawValue & rawValue) != 0
    }
    
    @inline(__always)
    static func from(flags: RawValue) -> Set<Self> {
        
        return Self.all.filter({ $0.isContained(in: flags) })
    }
}
