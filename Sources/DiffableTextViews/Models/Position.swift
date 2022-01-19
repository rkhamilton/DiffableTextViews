//
//  Position.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

//*============================================================================*
// MARK: * Position
//*============================================================================*

/// A model that represents the position in text, according to its text scheme.
///
/// Text views are not usually based on characters. UITextField counts its positions in UTF16 units, for example.
/// This destinction is important because emojis are one character in size but sometimes mutlitple UTF16 units,
/// and if this is not aknowledged you would attempt to access positions out of bounds and crash the application.
///
@usableFromInline struct Position<Scheme: DiffableTextViews.Scheme>: Equatable, Comparable, ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let offset: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ offset: Int) {
        self.offset = offset
    }
    
    @inlinable init(integerLiteral value: Int) {
        self.offset = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var start: Self {
        Self(0)
    }
    
    @inlinable static func end(of character: Character) -> Self {
        Self(Scheme.size(of: character))
    }
        
    @inlinable static func end<S: StringProtocol>(of characters: S) -> Self {
        Self(Scheme.size(of: characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func after(_ character: Character) -> Self {
        Self(offset + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character) -> Self {
        Self(offset - Scheme.size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset <  rhs.offset
    }
}
