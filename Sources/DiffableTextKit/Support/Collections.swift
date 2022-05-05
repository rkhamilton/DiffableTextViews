//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Extension
//*============================================================================*

public extension RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(capacity: Int) {
        self.init()
        self.reserveCapacity(capacity)
    }
    
    @inlinable init(capacity: Int, transform: (inout Self) -> Void) {
        self.init()
        self.reserveCapacity(capacity)
        transform(&self)
    }
    
    @inlinable init(transform: (inout Self) -> Void) {
        self.init()
        transform(&self)
    }
}
