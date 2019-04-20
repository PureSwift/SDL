//
//  CountableSet.swift
//  SDL
//
//  Created by Alsey Coleman Miller on 10/19/18.
//

/// Static Integer-based array for use on the stack.
///
/// Allows a count value to be used a collection.
/// Each element is basically a valid index in the collection (e.g. `0 ..< count`).
public struct CountableSet <Element: IndexRepresentable>: Collection {
    
    public typealias Index = Int
    
    public init(count: Int) {
        
        precondition(count >= 0, "Invalid negative value \(count)")
        
        self.count = count
    }
    
    public var count: Int
    
    public subscript (index: Index) -> Element {
        
        assert(index < count, "Invalid index")
        
        return Element(rawValue: index)
    }
    
    /// The start `Index`.
    public var startIndex: Index {
        return 0
    }
    
    /// The end `Index`.
    ///
    /// This is the "one-past-the-end" position, and will always be equal to the `count`.
    public var endIndex: Index {
        return count
    }
    
    public func index(before i: Index) -> Index {
        return i - 1
    }
    
    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    public func makeIterator() -> IndexingIterator<CountableSet<Element>> {
        return IndexingIterator(_elements: self)
    }
}

/// A struct wrapper that represents an index value.
public protocol IndexRepresentable: RawRepresentable, Hashable {
    
    init(rawValue: Int)
    
    var rawValue: Int { get }
}

public extension IndexRepresentable {
    
    var hashValue: Int {
        
        return rawValue.hashValue
    }
}

public extension IndexRepresentable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.rawValue == rhs.rawValue
    }
}
