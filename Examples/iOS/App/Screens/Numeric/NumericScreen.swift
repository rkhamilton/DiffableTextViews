//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreen
//*============================================================================*

struct NumericScreen: View {
    typealias Value = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: Static
    //=------------------------------------------------------------------------=
    
    private static let boundsValue = Value.precision.value
    private static let boundsLimits = Interval((-boundsValue, boundsValue))
    private static let integerLimits = Interval((1, Value.precision.integer))
    private static let fractionLimits = Interval((0, Value.precision.fraction))

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State private var value = Decimal(string: "1234567.89")!
    @State private var style = Style.currency
    
    @State private var currencyCode = "USD"
    @State private var locale = Locale(identifier: "en_US")
    
    @State private var bounds = Interval((0, Self.boundsValue))
    @State private var integer = Self.integerLimits
    @State private var fraction = Interval((2, 2))

    @EnvironmentObject private var context: Context
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            controls
            Divider()
            diffableTextViewsExample
        }
        .environment(\.locale, locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var controls: some View {
        Scroller {
            diffableTextStyles
            customizationWheels
            boundsIntervalSliders
            integerIntervalSliders
            fractionIntervalSliders
            Spacer()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subcomponents
    //=------------------------------------------------------------------------=
    
    var diffableTextStyles: some View {
        Options($style)
    }
    
    var customizationWheels: some View {
        NumericScreenWheels(style, locale: $locale, currency: $currencyCode)
    }
    
    var boundsIntervalSliders: some View {
        Sliders("Bounds", values: $bounds, limits: Self.boundsLimits.closed).disabled(true)
    }
    
    var integerIntervalSliders: some View {
        Sliders("Integer digits length", values: $integer, limits: Self.integerLimits.closed)
    }
    
    var fractionIntervalSliders: some View {
        Sliders("Fraction digits length", values: $fraction, limits: Self.fractionLimits.closed)
    }

    @ViewBuilder var diffableTextViewsExample: some View {
        switch style {
        case .number:
            Example($value) {
                .number
                .bounds((0 as Value)...)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        case .currency:
            Example($value) {
                .currency(code: currencyCode)
                .bounds((0 as Value)...)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        case .percent:
            Example($value) {
                .percent
                .bounds((0 as Value)...)
                .precision(integer: integer.closed, fraction: fraction.closed)
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    enum Style: String, CaseIterable { case number, currency, percent }
}

//*============================================================================*
// MARK: * NumericScreen x Previews
//*============================================================================*

struct NumericTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        NumericScreen().preferredColorScheme(.dark)
    }
}

