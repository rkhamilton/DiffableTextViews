//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import Quick

//*============================================================================*
// MARK: * Field
//*============================================================================*

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme>: Mappable {
    @usableFromInline typealias Offset    = DiffableTextViews.Offset<Scheme>
    @usableFromInline typealias Carets    = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Selection = DiffableTextViews.Selection<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Selection

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(carets: Carets, selection: Selection) {
        self.carets = carets
        self.selection = selection
    }
    
    //
    // MARK: Initializers - Initial
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.carets = Carets(snapshot: Snapshot())
        self.selection = Selection(position: carets.lastIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at range: Range<Offset>) -> Range<Carets.Index> {
        carets.indices(at: range, start: selection.range)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Field - Attributes
//=----------------------------------------------------------------------------=
    
extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable func autocorrected() -> Self {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            carets.look(start: start, direction: carets[start].directionOfAttributes() ?? preference)
        }
        
        return map({ $0.selection = $0.selection.preferred(position) })
    }
}

//=----------------------------------------------------------------------------=
// MARK: Field - Carets
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func updated(carets newValue: Carets) -> Field {
        func position(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            _Field.similarities(current: current.lazy.map(\.rhs), next: next.lazy.map(\.rhs)).startIndex
        }
                
        let upperBound = position(current: carets.suffix(from: selection.upperBound),   next: newValue[...])
        let lowerBound = position(current: carets[selection.range], next: newValue.prefix(upTo: upperBound))
        
        return Field(carets: newValue, selection: Selection(range: lowerBound ..< upperBound)).autocorrected()
    }
    
    //
    // MARK: Transformations - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable func updated(carets newValue: Snapshot) -> Self {
        updated(carets: Carets(snapshot: newValue))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Field - Selection
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable func updated(selection newValue: Selection, intent: Direction?) -> Self {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            if carets[start].nonlookable(direction: preference) { return start }
            
            let direction = intent ?? preference
            let next = carets.look(start: start, direction: direction)
            
            switch direction {
            case preference: return next
            case  .forwards: return next < carets .lastIndex ? carets.index(after:  next) : next
            case .backwards: return next > carets.startIndex ? carets.index(before: next) : next
            }
        }
        
        return map({ $0.selection = newValue.preferred(position) }).autocorrected()
    }
    
    //
    // MARK: Transformations - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable func updated(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        updated(selection: Selection(range: newValue), intent: intent)
    }
    
    @inlinable func updated(selection newValue: Carets.Index, intent: Direction?) -> Self {
        updated(selection: Selection(position: newValue), intent: intent)
    }
    
    @inlinable func updated(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        updated(selection: Selection(range: indices(at: newValue)), intent: intent)
    }
    
    @inlinable func updated(selection newValue: Offset, intent: Direction?) -> Self {
        updated(selection: Selection(range: indices(at: newValue ..< newValue)), intent: intent)
    }
}

//*============================================================================*
// MARK: * Field x Namespace
//*============================================================================*

@usableFromInline enum _Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Similarities
    //=------------------------------------------------------------------------=
    
    @inlinable static func similarities<Current: BidirectionalCollection, Next: BidirectionalCollection>(current lhs: Current, next rhs: Next) -> Next.SubSequence where Current.Element == Symbol, Next.Element == Symbol {
        Similarities(lhs: lhs, rhs: rhs, options: options).rhsSuffix()
    }
    
    //
    // MARK: Similarities - Options
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let options: SimilaritiesOptions<Symbol> = {
        func step(current lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
            if lhs == rhs                               { return .continue      }
            else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
            else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
            else                                        { return .none          }
        }
        
        return .init(comparison: .instruction(step), inspection: .only({ !$0.attribute.contains(.formatting) }))
    }()
}
