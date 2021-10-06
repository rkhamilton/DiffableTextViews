//
//  Indices.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct IndexLoop<Base: Collection>: Sequence {
    public typealias Index = Base.Index
    public typealias Bound = Loop.Bound<Index>
    public typealias Range = Loop.Range<Index>
    public typealias Step = Loop.Step<Base>
    
    // MARK: Properties
        
    @usableFromInline let base: Base
    @usableFromInline let start: Bound
    @usableFromInline let end: Bound
    @usableFromInline let step: Step
    
    // MARK: Initializers

    @inlinable public init(_ base: Base, start: Bound, end: Bound, step: Step) {        
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    // MARK: Helpers
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: step.distance, limitedBy: end.position)
    }
    
    // MARK: Iterators
    
    @inlinable public func makeIterator() -> AnyIterator<Index> {
        let range = Range(unordered: (start, end))
        
        var position = start.position as Index?
        
        if !range.contains(position!) {
            position = next(position!)
        }
        
        return AnyIterator {
            guard let index = position, range.contains(index) else { return nil }
            
            defer { position = next(index) }
            return  index
        }
    }
}


