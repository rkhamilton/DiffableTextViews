//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Precision

/// - Note: Lower precision bounds are enforced only when the view is idle.
public struct _Precision<Value: _Precise> {
    @usableFromInline typealias Defaults = _PrecisionDefaults
    @usableFromInline typealias Total = _PrecisionTotal<Value>
    @usableFromInline typealias Parts = _PrecisionParts<Value>
    
    // MARK: Properties
    
    @usableFromInline let implementation: _PrecisionImplementation
    
    // MARK: Initializers
    
    @inlinable init(implementation: _PrecisionImplementation) {
        self.implementation = implementation
    }
    
    // MARK: Showcase: Styles

    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        implementation.showcaseStyle()
    }
    
    // MARK: Editable: Styles
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integer = Defaults.integerLowerBound...Value.maxLosslessIntegerDigits
        let fraction = Defaults.fractionLowerBound...Value.maxLosslessFractionDigits
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    #warning("Rename to clarify what it does differently.")
    @inlinable func editableStyle(count: _Count) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = Swift.max(Defaults.integerLowerBound, count.integer)
        let integer = Defaults.integerLowerBound...integerUpperBound
        
        let fractionLowerBound = Swift.max(Defaults.fractionLowerBound, count.fraction)
        let fraction = fractionLowerBound...fractionLowerBound
        
        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Editable: Validation
    
    @inlinable func editableValidationThatGeneratesCapacity(count: _Count) -> _Count? {
        implementation.editableValidationThatGeneratesCapacity(count: count)
    }
}

// MARK: - Precision: Total

public extension _Precision {

    // MARK: Digits
    
    @inlinable static func digits<R: RangeExpression>(_ total: R) -> Self where R.Bound == Int {
        .init(implementation: Total(total: total))
    }
    
    // MARK: Max
    
    @inlinable static func max(_ total: Int) -> Self {
        digits(Defaults.totalLowerBound...total)
    }
    
    // MARK: Max: Standard
        
    @inlinable static var max: Self {
        .max(Value.maxLosslessTotalDigits)
    }
}

// MARK: - Precision: Parts

public extension _Precision where Value: _UsesFloatingPointPrecision {

    // MARK: Digits
    
    @inlinable static func digits<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) -> Self where R0.Bound == Int, R1.Bound == Int {
        .init(implementation: Parts(integer: integer, fraction: fraction))
    }
    
    @inlinable static func digits<R: RangeExpression>(integer: R) -> Self where R.Bound == Int {
        .init(implementation: Parts(integer: integer, fraction: Defaults.fractionLowerBound...))
    }
    
    @inlinable static func digits<R: RangeExpression>(fraction: R) -> Self where R.Bound == Int {
        .init(implementation: Parts(integer: Defaults.integerLowerBound..., fraction: fraction))
    }
    
    // MARK: Max
    
    @inlinable static func max(integer: Int, fraction: Int) -> Self  {
        .digits(integer: Defaults.integerLowerBound...integer, fraction: Defaults.fractionLowerBound...fraction)
    }
    
    @inlinable static func max(integer: Int) -> Self {
        .max(integer: integer, fraction: Value.maxLosslessTotalDigits - integer)
    }
    
    @inlinable static func max(fraction: Int) -> Self {
        .max(integer: Value.maxLosslessTotalDigits - fraction, fraction: fraction)
    }
}

// MARK: - Implementations

@usableFromInline protocol _PrecisionImplementation {
    typealias Defaults = _PrecisionDefaults
    
    // MARK: Requirements
        
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision
        
    @inlinable func editableValidationThatGeneratesCapacity(count: _Count) -> _Count?
}

// MARK: - Implementations: Total

@usableFromInline struct _PrecisionTotal<Value: _Precise>: _PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let total: ClosedRange<Int>
    
    // MARK: Initializers
    
    @inlinable init<R: RangeExpression>(total: R) where R.Bound == Int {
        self.total = ClosedRange(total.relative(to: 0 ..< Value.maxLosslessTotalDigits + 1))
        
        precondition(self.total.upperBound <= Value.maxLosslessTotalDigits, "Precision: max \(Value.maxLosslessTotalDigits).")
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .significantDigits(total)
    }
    
    @inlinable func editableValidationThatGeneratesCapacity(count: _Count) -> _Count? {
        let sharedCapacity = total.upperBound - count.total
        guard sharedCapacity >= 0 else { return nil }

        return .init(integer: sharedCapacity, fraction: sharedCapacity)
    }
}

// MARK: - Implementations: Parts

@usableFromInline struct _PrecisionParts<Value: _Precise>: _PrecisionImplementation {

    // MARK: Properties
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>

    // MARK: Initializers
    
    @inlinable init<R0: RangeExpression, R1: RangeExpression>(integer: R0, fraction: R1) where R0.Bound == Int, R1.Bound == Int {
        self.integer  = ClosedRange(integer.relative(to: 0 ..< Value.maxLosslessIntegerDigits  + 1))
        self.fraction = ClosedRange(integer.relative(to: 0 ..< Value.maxLosslessFractionDigits + 1))

        let total = self.fraction.lowerBound + self.integer.lowerBound
        precondition(total <= Value.maxLosslessTotalDigits, "Precision: max \(Value.maxLosslessTotalDigits).")
    }
    
    @inlinable init<R: RangeExpression>(integer: R) where R.Bound == Int {
        self.init(integer: integer, fraction: Defaults.fractionLowerBound...)
    }
    
    @inlinable init<R: RangeExpression>(fraction: R) where R.Bound == Int {
        self.init(integer: Defaults.integerLowerBound..., fraction: fraction)
    }
    
    // MARK: Utilities
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    @inlinable func editableValidationThatGeneratesCapacity(count: _Count) -> _Count? {
        guard Value.maxLosslessTotalDigits - count.total >= 0 else { return nil }
        
        let integerCapacity = integer.upperBound - count.integer
        guard integerCapacity >= 0 else { return nil }
        
        let fractionCapacity = fraction.upperBound - count.fraction
        guard fractionCapacity >= 0 else { return nil }
        
        return .init(integer: integerCapacity, fraction: fractionCapacity)
    }
}

// MARK: - Defaults

@usableFromInline enum _PrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let integerLowerBound: Int = 1
    @usableFromInline static let fractionLowerBound: Int = 0
}
