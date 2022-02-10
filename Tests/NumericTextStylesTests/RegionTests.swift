//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
import XCTest

@testable import NumericTextStyles

//*============================================================================*
// MARK: * RegionTests
//*============================================================================*

final class RegionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var regions: [Region] = Locale
        .availableIdentifiers.lazy
        .map(Locale.init)
        .map(Region.init)
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func int(_ region: Region) -> IntegerFormatStyle<Int> {
        .number.locale(region.locale)
    }
    
    @inlinable func double(_ region: Region) -> FloatingPointFormatStyle<Double> {
        .number.locale(region.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        let positive: Int = +1
        let negative: Int = -1
        
        for region in regions {
            let style = int(region).sign(strategy: .always())
            let positives = positive.formatted(style)
            let negatives = negative.formatted(style)
            XCTAssertNotNil(positives.first(where: { region.signs[$0] != nil }))
            XCTAssertNotNil(negatives.first(where: { region.signs[$0] != nil }))
        }
    }
    
    func testDigits() {
        let number: Int = 1234567890
        
        for region in regions {
            let style = int(region).grouping(.never)
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy({ region.digits[$0] != nil }))
        }
    }
    
    func testGroupingSeparators() {
        let number: Int = 1234567890
        
        for region in regions {
            let style = int(region).grouping(.automatic)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ region.separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        let number: Double = 0.123
        
        for region in regions {
            let style = double(region).decimalSeparator(strategy: .always)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ region.separators[$0] == .fraction }))
        }
    }
}

#endif
