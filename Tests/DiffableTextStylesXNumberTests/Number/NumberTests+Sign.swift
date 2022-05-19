//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
@testable import DiffableTextStylesXNumber

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class NumberTestsXSign: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertASCII(_ sign: Sign, _ character: Character) {
         XCTAssertEqual(sign.character, character)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        XCTAssertASCII(.positive, "+")
        XCTAssertASCII(.negative, "-")
    }
}

#endif
