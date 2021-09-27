//
//  &Range.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

extension Range {
    @inlinable func map<Value>(_ transform: (Bound) -> Value) -> Range<Value> {
        transform(lowerBound) ..< transform(upperBound)
    }
}
