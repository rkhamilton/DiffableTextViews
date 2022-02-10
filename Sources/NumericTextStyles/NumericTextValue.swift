//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias Value = NumericTextValue
@usableFromInline typealias FloatingPoint = NumericTextFloatingPointValue
@usableFromInline typealias Integer = NumericTextIntegerValue
@usableFromInline typealias Signed = NumericTextSignedValue
@usableFromInline typealias Unsigned = NumericTextUnsignedValue

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol NumericTextValue: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Data
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self { get }
    @inlinable static var precision: Count { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

public protocol NumericTextFloatingPointValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger: Bool { false }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable internal static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Signed Numeric
//=----------------------------------------------------------------------------=

extension NumericTextFloatingPointValue where Self: SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(limit: Self) -> ClosedRange<Self> {
        -limit...limit
    }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol NumericTextIntegerValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextIntegerValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger: Bool { true }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable internal static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fixed Width
//=----------------------------------------------------------------------------=

extension NumericTextIntegerValue where Self: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds() -> ClosedRange<Self> {
        min...max
    }
}

//*============================================================================*
// MARK: * Value x Signed
//*============================================================================*

public protocol NumericTextSignedValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextSignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol NumericTextUnsignedValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextUnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { true }
}
