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
// MARK: * Graph x Int
//*============================================================================*

public struct _Graph_Int<Value: _Input>: _Graph
where Value: FixedWidthInteger, Value: SignedInteger {
    public typealias Base = IntegerFormatStyle<Value>

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=

//    public typealias Number   = _DefaultID_Standard<Base         >.Style
//    public typealias Currency = _DefaultID_Currency<Base.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(precision: Int, min: Value = .min, max: Value = .min) {
        self.min = min; self.max = max; self.precision = precision
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var zero: Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { false }
    
    @inlinable @inline(__always) public var integer:  Bool { true  }
}

//=----------------------------------------------------------------------------=
// MARK: + Int
//=----------------------------------------------------------------------------=

extension Int: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Int<Self>
    public static let _numberTextGraph = _Graph_Int<Self>(precision: String(describing: Self.max).count)
}

//=----------------------------------------------------------------------------=
// MARK: + Int8
//=----------------------------------------------------------------------------=

extension Int8: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Int<Self>
    public static let _numberTextGraph = _Graph_Int<Self>(precision: 3)
}

//=----------------------------------------------------------------------------=
// MARK: + Int16
//=----------------------------------------------------------------------------=

extension Int16: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Int<Self>
    public static let _numberTextGraph = _Graph_Int<Self>(precision: 5)
}

//=----------------------------------------------------------------------------=
// MARK: + Int32
//=----------------------------------------------------------------------------=

extension Int32: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Int<Self>
    public static let _numberTextGraph = _Graph_Int<Self>(precision: 10)
}

//=----------------------------------------------------------------------------=
// MARK: + Int64
//=----------------------------------------------------------------------------=

extension Int64: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Int<Self>
    public static let _numberTextGraph = _Graph_Int<Self>(precision: 19)
}
