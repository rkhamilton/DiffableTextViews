//
//  PatternTextStyle+Placeholder.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import Support

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Placeholder
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ placeholder: Character, where predicate: Predicate) -> Self {
        var result = self; result.placeholders[placeholder] = predicate; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Placeholder - Public
//=----------------------------------------------------------------------------=

public extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A placeholder character and a variable predicate bound to a value.
    @inlinable func placeholder<Value: Hashable>(_ placeholder: Character,
        value: Value, where predicate: @escaping (Character) -> Bool) -> Self {
        transform(placeholder, where: Predicate(proxy: value, check: predicate))
    }
    
    /// A placeholder character and a constant predicate.
    @inlinable func placeholder(_ placeholder: Character,
        where predicate: @escaping (Character) -> Bool) -> Self {
        transform(placeholder, where: Predicate(proxy: Constant(), check: predicate))
    }
    
    /// A placeholder character and a constant predicate that always evaluates true.
    @inlinable func placeholder(_ placeholder: Character) -> Self {
        transform(placeholder, where: Predicate(proxy: Constant(), check: { _ in true }))
    }
}
