//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

#warning("Require: static var precision: Int { get }.")

// MARK: - Precise

public protocol Precise {
    
    // MARK: Requirements
    
    @inlinable static var maxLosslessIntegerDigits:     Int { get }
    @inlinable static var maxLosslessFractionDigits:    Int { get }
    @inlinable static var maxLosslessSignificantDigits: Int { get }
}

// MARK: - Precise: Details

extension Precise {
    
    // MARK: Min
    
    @inlinable static var minLosslessIntegerDigits:     Int { 1 }
    @inlinable static var minLosslessFractionDigits:    Int { 0 }
    @inlinable static var minLosslessSignificantDigits: Int { 1 }
    
    // MARK: Bounds
    
    @inlinable static var losslessIntegerLimits: ClosedRange<Int> {
        minLosslessIntegerDigits ... maxLosslessIntegerDigits
    }
    
    @inlinable static var losslessFractionLimits: ClosedRange<Int> {
        minLosslessFractionDigits ... maxLosslessFractionDigits
    }
    
    @inlinable static var losslessSignificantLimits: ClosedRange<Int> {
        minLosslessSignificantDigits ... maxLosslessSignificantDigits
    }
}

// MARK: - PreciseFloat

public  protocol PreciseFloat: Precise { }

// MARK: - PreciseFloat: Details

public extension PreciseFloat {
    
    // MARK: Implementation

    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        maxLosslessSignificantDigits
    }
}

// MARK: - PreciseInt

public  protocol PreciseInt: Precise { }

// MARK: - PreciseInt: Details

public extension PreciseInt {
    
    // MARK: Implementation
    
    @inlinable static var maxLosslessIntegerDigits: Int {
        maxLosslessSignificantDigits
    }
    
    @inlinable static var maxLosslessFractionDigits: Int {
        Int.zero
    }
}
