//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

#warning("Require: static var bounds: Self { get }.")

// MARK: - Boundable

public protocol Boundable: Comparable {
    
    // MARK: Requirements
    
    /// The zero value.
    @inlinable static var zero: Self { get }
    
    /// - Less than or equal to zero.
    @inlinable static var minLosslessValue: Self { get }
    
    /// - Greater than or equal to zero.
    @inlinable static var maxLosslessValue: Self { get }
}

// MARK: - Boundable x FloatingPoint

@usableFromInline protocol BoundableFloatingPoint: Boundable, BinaryFloatingPoint { }
extension BoundableFloatingPoint {
    
    // MARK: Implementation
    
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
}

// MARK: - Boundable x Integer

@usableFromInline protocol BoundableInteger: Boundable, FixedWidthInteger { }
extension BoundableInteger {
    
    // MARK: Implementation
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }
}

