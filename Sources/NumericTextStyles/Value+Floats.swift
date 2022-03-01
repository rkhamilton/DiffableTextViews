//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension Double: Values.Signed, Values.FloatingPoint {
    public typealias NumericTextFormat_Number   = FloatingPointFormatStyle<Self>
    public typealias NumericTextFormat_Currency = FloatingPointFormatStyle<Self>.Currency
    public typealias NumericTextFormat_Percent  = FloatingPointFormatStyle<Self>.Percent

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(15)
    public static let bounds: ClosedRange<Self> = bounds(999_999_999_999_999)
}
