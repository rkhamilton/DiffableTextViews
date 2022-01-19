//
//  Ints.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension Int: IntegerValue, SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(String(max).count)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension Int8: IntegerValue, SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension Int16: IntegerValue, SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension Int32: IntegerValue, SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension Int64: IntegerValue, SignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(19)
    public static let bounds: ClosedRange<Self> = bounds()
}
