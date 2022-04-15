//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Field
//*============================================================================*

/// A model describing a snapshot and a selection in it.
///
/// - Autocorrects selection when the snapshot changes.
/// - Autocorrects selection when the selection changes.
///
@usableFromInline struct Field {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var snapshot: Snapshot
    @usableFromInline var selection: Range<Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot; self.selection = .empty(snapshot.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func positions<T>(as type: Position<T>.Type =
    Position<T>.self) -> Range<T.Position> where T: Offset {
        snapshot.positions(at: selection)
    }    
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let selection = Range.map(selection, // proposed selection is calculated first
        lower: { Mismatches .forwards(from: self.snapshot[..<$0], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0...], to: snapshot).next })
        self.snapshot = snapshot; self.update(selection: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=

    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        let selection = snapshot.indices(at: selection) // translate positions as indices
        let momentum = momentum ? Directions(from: self.selection, to: selection) : .none
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Index>, momentum: Directions = .none) {
        if selection == snapshot.range { return self.selection = selection } // accept max value
        self.selection = Range.map(selection, // set preferred carets based on snapshot attributes
        lower: { snapshot.caret(from: $0, towards: momentum.lowerBound, preferring:  .forwards) },
        upper: { snapshot.caret(from: $0, towards: momentum.upperBound, preferring: .backwards) })
    }
}
