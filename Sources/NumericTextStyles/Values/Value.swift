//
//  Value.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol Value: Boundable, Precise {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

public protocol FloatingPointValue: Value, BoundableFloatingPoint, PreciseFloatingPoint { }

//=----------------------------------------------------------------------------=
// MARK: Value x Floating Point - Details
//=----------------------------------------------------------------------------=

public extension FloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var isInteger: Bool { false }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol IntegerValue: Value, BoundableInteger, PreciseInteger { }

//=----------------------------------------------------------------------------=
// MARK: Value x Integer - Details
//=----------------------------------------------------------------------------=

public extension IntegerValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var isInteger: Bool { true }
}

//*============================================================================*
// MARK: * Value x Signed
//*============================================================================*

public protocol SignedValue: Value { }

//=----------------------------------------------------------------------------=
// MARK: Value x Signed - Details
//=----------------------------------------------------------------------------=

public extension SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol UnsignedValue: Value { }

//=----------------------------------------------------------------------------=
// MARK: Value x Unsigned - Details
//=----------------------------------------------------------------------------=

public extension UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var isUnsigned: Bool { true }
}
