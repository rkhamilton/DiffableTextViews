//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

// MARK: - Field

#warning("Rename as Field.")
@usableFromInline struct Field<Layout: TextFields.Layout> {
    @usableFromInline typealias Carets = TextFields.Carets<Layout>
    
    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Range<Carets.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = Carets(snapshot)
        self.selection = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ field: Carets, selection: Range<Carets.Index>) {
        self.carets = field
        self.selection = selection
    }
    
    // MARK: Descriptions
    
    #warning("Make an OffsetUTF16 struct, so that it can't be accidentally misused.")
    @inlinable func offsets16() -> Range<Int> {
        fatalError()
//        let start = carets.offset16(from: carets.startIndex, to: selection.lowerBound)
//        let count = carets.offset16(from: selection.lowerBound, to: selection.upperBound)
//
//        return start ..< (start + count)
    }
    
    // MARK: Translate: To Carets
    
    @inlinable func translate(to newValue: Carets) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .inspect(.only(\.content))
            .compare(.equatable(\.character))
        
        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            next.lazy.map(\.rhs).suffix(alsoIn: current.lazy.map(\.rhs), options: options).startIndex
        }
        
        // --------------------------------- //
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: carets[selection], to: newValue[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(newValue, selection: nextLowerBound ..< nextUpperBound).moveToContent()
    }
    
    @inlinable func translate(to newValue: Snapshot) -> Self {
        translate(to: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    @inlinable func configure(selection newValue: Range<Carets.Index>) -> Self {
        move(to: newValue).moveToContent()
    }
    
    @inlinable func configure(selection newValue: Range<Int>) -> Self {
        typealias Path = (start: Carets.Index, offset: Int)
        
        var positions = [Carets.Index](size: 5)
        positions.append(contentsOf: [carets.firstIndex, carets.lastIndex])
        positions.append(contentsOf: [selection.lowerBound, selection.upperBound])
        
        func path(from position: Carets.Index, to offset: Int) -> Path {
            Path(start: position, offset: offset - position.offset)
        }
                
        func position(at offset: Int, append: Bool) -> Carets.Index {
            let paths = positions.map({ path(from: $0, to: offset) })
            let shortest = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position = carets.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                positions.append(position)
            }
            
            return position
        }
        
        let lowerBound = position(at: newValue.lowerBound, append: true)
        let upperBound = position(at: newValue.upperBound, append: false)
                        
        return configure(selection: lowerBound ..< upperBound)
    }
    
    // MARK: Configure: Position
    
    @inlinable func configure(selection newValue: Carets.Index) -> Self {
        configure(selection: newValue ..< newValue)
    }
    
    // MARK: Helpers: Update
    
    @inlinable func update(_ transform: (inout Field) -> Void) -> Field {
        var copy = self; transform(&copy); return copy
    }

    // MARK: Move: To Content
    
    @inlinable func moveToContent() -> Field {
        func position(_ position: Carets.Index) -> Carets.Index {
            var position = position
            
            func condition() -> Bool {
                let element = carets[position]; return element.lhs.noncontent && element.rhs.noncontent
            }
                        
            func move(_ direction: Walkthrough<Carets>.Step, towards predicate: (Carets.Element) -> Bool) {
                position = carets.firstIndex(in: .stride(start: .closed(position), step: direction), where: predicate) ?? position
            }
            
            if condition() {
                move(.backwards, towards: { $0.lhs.content || $0.lhs.prefix })
            }
            
            if condition() {
                move(.forwards,  towards: { $0.rhs.content || $0.rhs.suffix })
            }
            
            return position
        }
        
        // --------------------------------- //
        
        let lowerBound = position(selection.lowerBound)
        let upperBound = position(selection.upperBound)
        
        // --------------------------------- //

        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Move: To, Jumps Over Spacers
    
    @inlinable func move(to newValue: Range<Carets.Index>) -> Field {
        func momentum(from first: Carets.Index, to second: Carets.Index) -> Walkthrough<Carets>.Step? {
            if      first < second { return  .forwards }
            else if first > second { return .backwards }
            else                   { return      .none }
        }
        
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Walkthrough<Carets>.Step, where predicate: (Carets.Element) -> Bool) -> Carets.Index {
            let position = positionIn(newValue)
            let momentum = momentum(from: positionIn(selection), to: position) ?? preference
    
            return carets.firstIndex(in: .stride(start: .closed(position), step: momentum), where: predicate) ?? position
        }
        
        // --------------------------------- //
        
        let upperBound = position(\.upperBound, preference: .backwards, where: \.lhs.nonspacer)
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, where: \.rhs.nonspacer)
        }
        
        // --------------------------------- //
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
}
