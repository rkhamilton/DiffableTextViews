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
@testable import DiffableTextStylesXPattern

//*============================================================================*
// MARK: Declaration
//*============================================================================*

protocol StyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var style: PatternTextStyle<String> { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNone()
    func testSome()
    func testFull()
    func testMore()
        
    //=------------------------------------------------------------------------=
    // MARK: Tests - Mismatches
    //=------------------------------------------------------------------------=
    
    func testNoneMismatch()
    func testSomeMismatch()
}

//=----------------------------------------------------------------------------=
// MARK: Style
//=----------------------------------------------------------------------------=
    
extension StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTFormat___(_ input: String, format: String) {
         XCTAssertEqual(style.format(input),   format)
    }
    
    func XCTInterpret(_ input: String, format: String, value: String) {
        let testable = style.interpret(input)
        XCTAssertEqual(testable.value, value)
        XCTAssertEqual(testable.snapshot.characters, format)
    }
}

#endif
