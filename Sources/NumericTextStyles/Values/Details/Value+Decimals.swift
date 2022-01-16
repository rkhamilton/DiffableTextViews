//
//  Value+Decimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal: FloatingPointValue {

    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    public static let precision: Capacity = precision(38)
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=

    public static let bounds: ClosedRange<Self> = bounds(limit: Self(string: String(repeating: "9", count: 38))!)
    
    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=
    
    @inlinable public static func make(description: String) -> Optional<Self> {
        Self(string: description)
    }
}
