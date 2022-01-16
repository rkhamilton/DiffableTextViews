//
//  PatternTextStyle+.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        var snapshot = Snapshot()
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex
        //=--------------------------------------=
        // MARK: Prefix Up To First Placeholder
        //=--------------------------------------=
        while patternIndex != pattern.endIndex {
            let patternElement = pattern[patternIndex]
            if patternElement == placeholder { break }
            //=----------------------------------=
            // MARK: Insert
            //=----------------------------------=
            snapshot.append(Symbol(patternElement, as: .phantom))
            pattern.formIndex(after: &patternIndex)
        }
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        while patternIndex != pattern.endIndex, valueIndex != value.endIndex {
            let patternElement = pattern[patternIndex]
            pattern.formIndex(after: &patternIndex)
            //=----------------------------------=
            // MARK: Matches, Insert
            //=----------------------------------=
            if patternElement == placeholder {
                let valueElement = value[valueIndex]
                value.formIndex(after: &valueIndex)
                snapshot.append(Symbol(valueElement, as: .content))
            } else {
                snapshot.append(Symbol(patternElement, as: .phantom))
            }
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        if visible {
            //=----------------------------------=
            // MARK: Head
            //=----------------------------------=
            if valueIndex == value.startIndex {
                let endIndex = pattern.prefix(while: { $0 != placeholder }).endIndex
                snapshot.append(contentsOf: Snapshot(String(pattern[patternIndex..<endIndex]), as: .phantom))
                snapshot.append(.anchor)
                patternIndex = endIndex
            }
            //=----------------------------------=
            // MARK: Tail
            //=----------------------------------=
            snapshot.append(contentsOf: Snapshot(String(pattern[patternIndex...]), as: .phantom))
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Merge
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Snapshot {
        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=
        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: input.content)
        //=--------------------------------------=
        // MARK: Value, Continue
        //=--------------------------------------=
        return try self.snapshot(editable: parse(snapshot: proposal))
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Parse
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = Value(snapshot
            .lazy
            .filter({ !$0.attribute.contains(.formatting) })
            .map(\.character))
        //=--------------------------------------=
        // MARK: Validation
        //=--------------------------------------=
        try validate(value)
        try predicates.validate(value)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return value
    }
}
