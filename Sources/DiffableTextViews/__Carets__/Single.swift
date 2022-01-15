//
//  Single.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Single
//*============================================================================*

@usableFromInline struct Single<Scheme: DiffableTextViews.Scheme>: Caret {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>
    @usableFromInline typealias Index = DiffableTextViews.Positions<Scheme>.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let positions: Positions
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ positions: Positions) {
        self.positions = positions
    }

    //=------------------------------------------------------------------------=
    // MARK: Preference
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !passthrough(backwards: start) || !passthrough(forwards: start)
    }
    
    @inlinable func forwards(start: Index) -> Index? {
        var position = start

        while position != positions.endIndex {
            guard passthrough(position) else { return position }
            positions.formIndex(after: &position)
        }

        return nil
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        var position = start

        while position != positions.startIndex {
            let after = position
            positions.formIndex(before: &position)
            guard passthrough(position) else { return after }
        }

        return nil
    }
}

