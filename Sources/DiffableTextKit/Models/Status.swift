//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Status
//*===========================================================================

/// A model used to collect upstream and downstream values.
public struct Status<Style: DiffableTextStyle> {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    public var value: Value
    public var focus: Focus

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ style: Style, _ value: Value, _ focus: Focus) {
        self.style = style
        self.value = value
        self.focus = focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func merge(_ other: Self) -> Changes {
        let changes = (self .!= other)
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        if changes.contains(.style) { self.style = other.style }
        if changes.contains(.value) { self.value = other.value }
        if changes.contains(.focus) { self.focus = other.focus }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return changes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func .!= (lhs: Self, rhs: Self) -> Changes {
        var changes = Changes()
        //=--------------------------------------=
        // Compare
        //=--------------------------------------=
        if lhs.style != rhs.style { changes.formUnion(.style) }
        if lhs.value != rhs.value { changes.formUnion(.value) }
        if lhs.focus != rhs.focus { changes.formUnion(.focus) }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return changes
    }
}
