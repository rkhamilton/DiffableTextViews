//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Number (Standard)
//*============================================================================*

public typealias NumericTextStyle<Value: NumericTextValue> =
_NumericTextStyle<Value.FormatStyle>

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Currency
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormat_Currencyable {
    public typealias Currency = _NumericTextStyle<Format.Currency>
}

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Percent
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormat_Percentable {
    public typealias Percent = _NumericTextStyle<Format.Percent>
}
