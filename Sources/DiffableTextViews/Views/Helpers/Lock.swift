//
//  Lock.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-05.
//

// MARK: - Lock

@usableFromInline final class Lock {
    
    // MARK: Properties
    
    @usableFromInline private(set) var isLocked: Bool = false
    
    // MARK: Utilities
    
    @inlinable func perform(action: () -> Void) {
        let state = isLocked
        self.isLocked = true

        action()
        
        self.isLocked = state
    }
}
