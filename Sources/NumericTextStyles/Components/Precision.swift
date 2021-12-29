//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import enum Foundation.NumberFormatStyleConfiguration
import struct Utilities.Reason

// MARK: - Precision

/// - Note: Lower bound is enforced only when the view is idle.
public struct Precision<Value: Precise> {
    @usableFromInline typealias Implementation = PrecisionImplementation
    @usableFromInline typealias SignificantDigits = SignificantDigitsPrecision<Value>
    @usableFromInline typealias IntegerAndFractionLength = IntegerAndFractionLengthPrecision<Value>

    // MARK: Properties
    
    @usableFromInline let implementation: Implementation
    
    // MARK: Initializers
    
    @inlinable init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    // MARK: Validation
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        try implementation.capacity(number: number)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        implementation.showcaseStyle()
    }
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: Value.losslessIntegerLimits, fractionLimits: Value.losslessFractionLimits)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = max(Value.minLosslessIntegerDigits, number.integer.count)
        let integer = Value.minLosslessIntegerDigits...integerUpperBound
        let fractionLowerBound = max(Value.minLosslessFractionDigits, number.fraction.count)
        let fraction = fractionLowerBound...fractionLowerBound
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
}

// MARK: - Precision x Namespace

@usableFromInline enum _Precision {

    // MARK: Bounds
    
    @inlinable static func clamped<R: RangeExpression>(_ expression: R, to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range: Range<Int> = expression.relative(to: limits.lowerBound ..< limits.upperBound + 1)
        return Swift.max(limits.lowerBound, range.lowerBound) ... Swift.min(range.upperBound - 1, limits.upperBound)
    }
    
    // MARK: Capacity
    
    @inlinable static func capacity(number: Number, max: Capacity) throws -> Capacity {
        let integer = max.integer - number.integer.count
        guard integer >= 0 else {
            throw failure(excess: .integer, max: max.integer)
        }
        
        let fraction = max.fraction - number.fraction.count
        guard fraction >= 0 else {
            throw failure(excess: .fraction, max: max.fraction)
        }
        
        let significant = max.significant - number.significantCount()
        guard significant >= 0 else {
            throw failure(excess: .significant, max: max.significant)
        }
        
        return .init(integer: integer, fraction: fraction, significant: significant)
    }
    
    // MARK: Errors
    
    @inlinable static func failure(excess component: Component, max: Int) -> Reason {
        .reason(.mark(component), "digits exceeded precision capacity", .mark(max))
    }
    
    // MARK: Components
    
    @usableFromInline enum Component: String {
        case integer
        case fraction
        case significant
    }
}

// MARK: - Precision x Implementation

@usableFromInline protocol PrecisionImplementation {

    // MARK: Requirements
            
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
    
    @inlinable func capacity(number: Number) throws -> Capacity
}

// MARK: - Precision x SignificantDigits

@usableFromInline struct SignificantDigitsPrecision<Value: Precise>: PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let significant: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(_ significant: R) where R.Bound == Int {
        self.significant = _Precision.clamped(significant, to: Value.losslessSignificantLimits)
    }
    
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(significant)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let max = Capacity.max(in: Value.self, significant: significant.upperBound)
        return try _Precision.capacity(number: number, max: max)
    }
}

// MARK: - Precision x IntegerAndFractionLength

@usableFromInline struct IntegerAndFractionLengthPrecision<Value: Precise>: PrecisionImplementation {
    
    // MARK: Properties
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer  = _Precision.clamped(integer,  to: Value.losslessIntegerLimits)
        self.fraction = _Precision.clamped(fraction, to: Value.losslessFractionLimits)
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: Value.losslessFractionLimits)
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: Value.losslessIntegerLimits, fraction: fraction)
    }
    
    // MARK: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Capacity
    
    @inlinable func capacity(number: Number) throws -> Capacity {
        let max = Capacity.max(in: Value.self, integer: integer.upperBound, fraction: fraction.upperBound)
        return try _Precision.capacity(number: number, max: max)
    }
}

// MARK: - Instances: SignificantDigits

public extension Precision {

    // MARK: Limits
    
    @inlinable static func digits<R: RangeExpression>(_ significant: R) -> Self where R.Bound == Int {
        .init(SignificantDigits(significant))
    }
    
    // MARK: Fixed
    
    @inlinable static func digits(_ significant: Int) -> Self {
        self.init(SignificantDigits(significant...significant))
    }
    
    // MARK: Named
            
    @inlinable static var standard: Self {
        .init(SignificantDigits(Value.losslessSignificantLimits))
    }
}

// MARK: - Instances: IntegerAndFractionLength

public extension Precision where Value: PreciseFloatingPoint {
    
    // MARK: Limits

    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(fraction: fraction))
    }
    
    // MARK: Mixed
    
    @inlinable static func digits<R: RangeExpression>(integer: R, fraction: Int) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer, fraction: fraction...fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: Int, fraction: R) -> Self where R.Bound == Int {
        .init(IntegerAndFractionLength(integer: integer...integer, fraction: fraction))
    }
    
    // MARK: Fixed
    
    @inlinable static func digits(integer: Int, fraction: Int) -> Self {
        .init(IntegerAndFractionLength(integer: integer...integer, fraction: fraction...fraction))
    }
    
    @inlinable static func digits(integer: Int) -> Self {
        .init(IntegerAndFractionLength(integer: integer...integer))
    }
    
    @inlinable static func digits(fraction: Int) -> Self {
        .init(IntegerAndFractionLength(fraction: fraction...fraction))
    }
}
