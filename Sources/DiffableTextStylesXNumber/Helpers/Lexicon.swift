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
// MARK: Declaration
//*============================================================================*

public final class Lexicon {
    @usableFromInline typealias Signs = Links<Sign>
    @usableFromInline typealias Digits = Links<Digit>
    @usableFromInline typealias Separators = Links<Separator>

    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let ascii = Lexicon(
    signs: .ascii(), digits: .ascii(), separators: .ascii())
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs: Signs
    @usableFromInline let digits: Digits
    @usableFromInline let separators: Separators

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(signs: Signs, digits: Digits, separators: Separators) {
        self.signs = signs; self.digits = digits; self.separators = separators
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Lexicon {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .standard(formatter),
        digits:     .standard(formatter),
        separators: .standard(formatter))
    }
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Lexicon {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .currency(formatter),
        digits:     .currency(formatter),
        separators: .currency(formatter))
    }
}
