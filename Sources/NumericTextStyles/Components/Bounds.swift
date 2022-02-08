//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Bounds
//*============================================================================*

/// A model that constrains values to a closed range.
public struct Bounds<Value: Boundable>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self {
        Self(unchecked: (.zero, .zero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked bounds: (Value, Value)) {
        self.min = bounds.0
        self.max = bounds.1
    }
    
    @inlinable init(min: Value = Value.bounds.lowerBound, max: Value = Value.bounds.upperBound) {
        precondition(min <= max, "min > max"); (self.min, self.max) = (min, max)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    /// A model describing whether a value maxed out or not.
    @usableFromInline enum Location { case body, edge }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - Value
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws -> Location {
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        if min < value && value < max { return .body }
        //=--------------------------------------=
        // MARK: Edge
        //=--------------------------------------=
        if min == value || value == max {
            //=----------------------------------=
            // MARK: Special Cases About Zero
            //=----------------------------------=
            return value != .zero || self == .zero ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - Number
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=

    @inlinable func autocorrect(_ sign: inout Sign) {
        do { try validate(sign: sign) } catch { sign.toggle() }
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(sign: Sign) throws {
        switch sign {
        case .positive: if max > .zero || self == .zero { return }
        case .negative: if min < .zero                  { return }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(sign), "is not in", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Bounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "[\(min),\(max)]"
    }
}
