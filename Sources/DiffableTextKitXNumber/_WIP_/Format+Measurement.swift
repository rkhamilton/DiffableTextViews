//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Format x Measurement
//*============================================================================*

@usableFromInline struct _MeasurementFormat<Unit: Dimension>: _Format, Codable {
    
    @usableFromInline typealias FormatInput  = Double
    @usableFromInline typealias FormatOutput = String
    
    @usableFromInline typealias Base = Measurement<Unit>.FormatStyle
    @usableFromInline typealias Core = FloatingPointFormatStyle<Double>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var base: Base
    @usableFromInline private(set) var item: Item

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unit: Unit, width: Base.UnitWidth, locale: Locale) {
        self.base = Base(width: width, locale: locale,
        usage: .asProvided, numberFormatStyle:.number)
        self.item = Item(unit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var unit: Unit {
        get { item.unit }
        set { item.unit = newValue }
    }
    
    @inlinable var core: Core {
        get { base.numberFormatStyle! }
        set { base.numberFormatStyle! = newValue }
    }
    
    @inlinable var parseStrategy: Core.Strategy { core.parseStrategy }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: _NFSC_SignDS) -> Self {
        var S0 = self; S0.core = S0.core.sign(strategy: strategy); return S0
    }
    
    @inlinable func precision(_ precision: _NFSC.Precision) -> Self {
        var S0 = self; S0.core = S0.core.precision(precision); return S0
    }
    
    @inlinable func decimalSeparator(strategy: _NFSC_SeparatorDS) -> Self {
        var S0 = self; S0.core = S0.core.decimalSeparator(strategy: strategy); return S0
    }
    
    @inlinable func rounded(rule: _FPRR, increment: Double?) -> Self {
        var S0 = self; S0.core = S0.core.rounded(rule: rule, increment: increment); return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Double) -> String {
        base.format(Measurement(value: value, unit: unit))
    }
    
    //*========================================================================*
    // MARK: * Item [...]
    //*========================================================================*
    
    /// A Codable and Hashable wrapper around Unit.
    @usableFromInline struct Item: Codable, Hashable {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let measurement: Measurement<Unit>
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ unit: Unit) {
            self.measurement = Measurement(value: 0.0, unit: unit)
        }
        
        @inlinable var unit: Unit {
            get { measurement.unit } set { self = Self(newValue) }
        }
    }
}
