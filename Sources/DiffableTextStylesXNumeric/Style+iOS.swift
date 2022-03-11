//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if os(iOS)

import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * NumericTextStyle x iOS
//*============================================================================*

extension NumericTextStyle: DiffableTextStyleXiOS {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public static func onSetup(_ diffableTextField: ProxyTextField) {
        diffableTextField.keyboard.view(Value.isInteger ? .numberPad : .decimalPad)
    }
}

#endif

