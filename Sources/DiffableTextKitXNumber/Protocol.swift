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
// MARK: * Protocol
//*============================================================================*

public protocol NumberTextStyleProtocol: DiffableTextStyle where Value: NumberTextKind {
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    associatedtype Format: NumberTextFormat
    associatedtype Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    typealias Adapter = NumberTextAdapter<Format>
    typealias Bounds = NumberTextBounds<Format.FormatInput>
    typealias Precision = NumberTextPrecision<Format.FormatInput>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var adapter:   Adapter   { get set }
    @inlinable var bounds:    Bounds    { get set }
    @inlinable var precision: Precision { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumberTextStyleProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        format.locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var format: Format {
        adapter.format
    }
    
    @inlinable var reader: NumberTextReader {
        adapter.reader
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number(_ proposal: Proposal) throws -> Number? {
        try reader.number(proposal, as: Value.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumberTextStyleProtocol where Format: NumberTextFormatXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var currencyCode: String {
        adapter.format.currencyCode
    }
}
