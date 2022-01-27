//
//  Reader.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews

//*============================================================================*
// MARK: * Reader
//*============================================================================*

@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var content: Snapshot
    @usableFromInline var process: ((inout Number) -> Void)?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ content: Snapshot) {
        self.content = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSignInput(region: Region) {
        guard content.count == 1 else { return } // snapshot.count is O(1)
        guard let sign = region.signs[content.first!.character] else { return }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.content.removeAll()
        self.process = { number in number.sign = sign }
    }
}
