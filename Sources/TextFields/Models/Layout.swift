//
//  Layout.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Layout

@usableFromInline struct Layout<Scheme: LayoutScheme>: BidirectionalCollection {
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    // MARK: Collection: Indices
    
    @inlinable var startIndex: Index {
        Index(snapshot.startIndex, position: .init(.start))
    }
    
    @inlinable var endIndex: Index {
        Index(snapshot.endIndex, position: .init(.end))
    }
    
    // MARK: Collection: Traversal
    
    @inlinable func index(after index: Index) -> Index {
        let next = snapshot.index(before: index.snapshot)
        let size = Scheme.size(of: snapshot.characters[index.snapshot.character])
        return Index(next, position: index.position.after(stride: size))
    }
    
    @inlinable func index(before index: Index) -> Index {
        let next = snapshot.index(before: index.snapshot)
        let size = Scheme.size(of: snapshot.characters[next.character])
        return Index(next, position: index.position.before(stride: size))
    }
    
    // MARK: Collection: Subscript
    
    @inlinable subscript(position: Index) -> Symbol {
        _read {
            yield snapshot[position.snapshot]
        }
    }
    
    // MARK: Index
    
    @usableFromInline struct Index: Equatable, Comparable {
        
        // MARK: Properties
        
        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let position: Position
        
        // MARK: Initializers
        
        @inlinable init(_ snapshot: Snapshot.Index, position: Position) {
            self.snapshot = snapshot
            self.position = position
        }
        
        // MARK: Collection: Index
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.snapshot < rhs.snapshot
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.snapshot == rhs.snapshot
        }
    }
    
    // MARK: Location
    
    @usableFromInline struct Position {
        
        // MARK: Properties
        
        @usableFromInline let origin: Origin
        @usableFromInline let offset: Int
        
        // MARK: Initializers
        
        @inlinable init(_ origin: Origin, offset: Int = 0) {
            self.origin = origin
            self.offset = offset
        }
        
        // MARK: Transformations
        
        @inlinable func after(stride: Int) -> Self {
            .init(origin, offset: offset + stride)
        }
        
        @inlinable func before(stride: Int) -> Self {
            .init(origin, offset: offset - stride)
        }
        
        // MARK: Origin
        
        @usableFromInline enum Origin { case start, end }
    }
}

// MARK: - LayoutScheme

@usableFromInline protocol LayoutScheme {
    @inlinable static func size(of character: Character) -> Int
}

extension Character {
    @inlinable static func size(of character: Character) -> Int { 1 }
}

extension UTF8: LayoutScheme {
    @inlinable static func size(of character: Character) -> Int { character.utf8.count }
}

extension UTF16: LayoutScheme {
    @inlinable static func size(of character: Character) -> Int { character.utf16.count }
}
