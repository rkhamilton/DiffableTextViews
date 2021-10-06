//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct Range<Position: Comparable> {
    public typealias Bound = Loop.Bound<Position>
    
    // MARK: Properties
    
    @usableFromInline let lowerBound: Bound
    @usableFromInline let upperBound: Bound
    
    // MARK: Initializers
    
    @inlinable public init(lowerBound: Bound, upperBound: Bound) {
        precondition(lowerBound <= upperBound)

        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    @inlinable public init(unordered bounds: (Bound, Bound)) {
        self.lowerBound = Swift.min(bounds.0, bounds.1)
        self.upperBound = Swift.max(bounds.0, bounds.1)
    }
    
    // MARK: Utilities
    
    @inlinable public func contains(_ position: Position) -> Bool {
        lowerBound <= position && position <= upperBound
    }
}
