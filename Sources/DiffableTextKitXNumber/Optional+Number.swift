//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Optional x Number
//*============================================================================*

extension _OptionalNumberTextStyle where Format: NumberTextFormatXNumber {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.init(Format(locale: locale))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Double
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Int
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Int8
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int8?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Int16
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int16?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Int32
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int32?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Int64
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int64?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt8
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt8?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt16
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt16?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt32
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt32?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt64
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt64?> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var number: Self {
        Self()
    }
}
