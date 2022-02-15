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
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias Format = NumericTextFormat
@usableFromInline typealias Normal = NumericTextNumberFormat
@usableFromInline typealias Currency = NumericTextCurrencyFormat
@usableFromInline typealias Percent = NumericTextPercentFormat

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol NumericTextFormat: ParseableFormatStyle where FormatInput: NumericTextValue, FormatOutput == String {
    associatedtype SignDisplayStrategy: NumericTextSignDisplayStrategyRepresentable

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: SignDisplayStrategy) -> Self
    @inlinable func precision(_ precision: NumberFormatStyleConfiguration.Precision) -> Self
    @inlinable func decimalSeparator(strategy: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFormat {
    @usableFromInline typealias Value = FormatInput
    @usableFromInline typealias Precision = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Sign = NumericTextSignDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func separator(_ strategy: Self.Separator) -> Self {
        self.decimalSeparator(strategy: strategy)
    }
    
    @inlinable func sign(_ strategy: Self.Sign) -> Self {
        self.sign(strategy: SignDisplayStrategy(strategy: strategy))
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumericTextNumberFormat: NumericTextFormat where
SignDisplayStrategy == NumberFormatStyleConfiguration.SignDisplayStrategy { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumericTextCurrencyFormat: NumericTextFormat where
SignDisplayStrategy == CurrencyFormatStyleConfiguration.SignDisplayStrategy { }


//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

/// - Note: To use this format, the value must support at least two exponent digits.
public protocol NumericTextPercentFormat: NumericTextFormat where
FormatInput: NumericTextFloatingPointValue,
SignDisplayStrategy == NumberFormatStyleConfiguration.SignDisplayStrategy { }
