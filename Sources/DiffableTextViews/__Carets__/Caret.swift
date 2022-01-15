//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Caret
//*============================================================================*

@usableFromInline protocol Caret {
    associatedtype Scheme: DiffableTextViews.Scheme
    typealias Positions = DiffableTextViews.Positions<Scheme>
    typealias Index = DiffableTextViews.Positions<Scheme>.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable var positions:  Positions { get }
    @inlinable var preference: Direction { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func  validate(start: Index) -> Bool
    @inlinable func  forwards(start: Index) -> Index?
    @inlinable func backwards(start: Index) -> Index?
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Helpers
//=----------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Passthrough
    //=------------------------------------------------------------------------=
    
    @inlinable func passthrough(_ position: Index) -> Bool {
        positions[position].attribute.contains(.passthrough)
    }
    
    @inlinable func passthrough(forwards position: Index) -> Bool {
        position != positions.endIndex ? passthrough(position) : true
    }
    
    @inlinable func passthrough(backwards position: Index) -> Bool {
        position != positions.startIndex ? passthrough(positions.index(before: position)) : true
    }
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Utilities
//=----------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Move
    //=------------------------------------------------------------------------=
    
    @inlinable func move(start: Index, direction: Direction) -> Index? {
        switch direction {
        case  .forwards: return  forwards(start: start)
        case .backwards: return backwards(start: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(position: Index, intent: Direction?) -> Index? {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if validate(start: position) { return position }
        //=--------------------------------------=
        // MARK: Choose A Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try It, Try The Other
        //=--------------------------------------=
        if let next = move(start: position, direction: direction)            { return next }
        if let next = move(start: position, direction: direction.reversed()) { return next }
        //=--------------------------------------=
        // MARK: No Acceptable Position Found
        //=--------------------------------------=
        return nil
    }
}
