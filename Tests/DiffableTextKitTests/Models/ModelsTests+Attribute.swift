//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTextKit
import XCTest

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ModelsTestsXAttribute: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let attributes: [Attribute] = [.virtual, .insertable, .removable, .passthrough]

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testContentIsEmpty() {
        XCTAssert(Attribute.content.isEmpty)
    }
    
    func testAttributesAreUnique() {
        XCTAssertEqual(Set(attributes.map(\.rawValue)).count, attributes.count)
    }
}

#endif
