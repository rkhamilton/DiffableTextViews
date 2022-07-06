//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Momentums x Tests
//*============================================================================*

final class MomentumsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertEqual(_ momentums: Momentums, lower: Direction?, upper: Direction?) {
        XCTAssertEqual(momentums.lower, lower)
        XCTAssertEqual(momentums.upper, upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Instances
    //=------------------------------------------------------------------------=
    
    func testInstanceNoneContainsOnlyNil() {
        AssertEqual(.none, lower: nil, upper: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitLowerUpperSetsLowerUpper() {
        let momentums = Momentums(lower: .forwards, upper: .backwards)
        AssertEqual(momentums,    lower: .forwards, upper: .backwards)
    }
    
    func testInitFromToSetsDirectionsOfChange() {
        AssertEqual(Momentums(
        from: Selection(3 ..< 7), to: Selection(3 ..< 7)),
        lower: nil, upper: nil)

        AssertEqual(Momentums(
        from: Selection(3 ..< 7), to: Selection(4 ..< 6)),
        lower: .forwards, upper: .backwards)

        AssertEqual(Momentums(
        from: Selection(3 ..< 7), to: Selection(2 ..< 8)),
        lower: .backwards, upper: .forwards)
    }
}

#endif
