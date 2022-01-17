//
//  NumericTextStyle+.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(characters: showcaseStyle().format(value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(characters: editableStyle().format(value))
    }

    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=

    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(characters: String) -> Snapshot {
        characters.reduce(into: Snapshot()) { snapshot, character in
            let attribute: Attribute
            //=----------------------------------=
            // MARK: Match
            //=----------------------------------=
            if let _ = region.digits[character] {
                attribute = .content
            } else if let separator = region.separators[character] {
                attribute = separator == .fraction ? .removable : .phantom
            } else if let _ = region.signs[character] {
                attribute = .phantom.subtracting(.virtual)
            } else {
                attribute = .phantom
            }
            //=----------------------------------=
            // MARK: Insert
            //=----------------------------------=
            snapshot.append(Symbol(character, as: attribute))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Merge
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value> {
        //=--------------------------------------=
        // MARK: Reader, Proposal
        //=--------------------------------------=
        var reader = Reader(input.content)
        reader.consumeSignInput(region: region)

        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: reader.content)
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        var number = try region.number(in: proposal, as: Value.self)
        reader.process?(&number)
        try bounds.validate(sign: number.sign)
        //=--------------------------------------=
        // MARK: Count, Capacity
        //=--------------------------------------=
        var count = number.count()
        format.process(count: &count)

        let capacity = try precision.capacity(count: count)
        number.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try parser.parse(region.characters(in: number))
        try bounds.validate(value: value)
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        var characters = editableStyle(number: number).format(value)
        autocorrectSign(in: &characters, with: value, and: number.sign)
        //=--------------------------------------=
        // MARK: Continue
        //=--------------------------------------=
        return Output(self.snapshot(characters: characters), value: value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Parse
//=----------------------------------------------------------------------------=

extension NumericTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot As Value
    //=------------------------------------------------------------------------=

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try parser.parse(snapshot.characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Process
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=

    @inlinable public func process(value: inout Value) {
        bounds.clamp(&value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

extension NumericTextStyle: UIKitTextStyle {    
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}

#endif
