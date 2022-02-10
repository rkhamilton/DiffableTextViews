//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
// MARK: * Value x Affordances
//*============================================================================*

public protocol NumericTextIntegerValue: NumericTextValue { }
public protocol NumericTextFloatingPointValue: NumericTextValue { }

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

@usableFromInline protocol FloatingPoint: NumericTextFloatingPointValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension FloatingPoint {
    
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

extension FloatingPoint where Self: SignedNumeric {
    
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

@usableFromInline protocol Integer: NumericTextIntegerValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Integer {
    
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

extension Integer where Self: FixedWidthInteger {
    
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

@usableFromInline protocol Signed: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Signed {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

@usableFromInline protocol Unsigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Unsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { true }
}
