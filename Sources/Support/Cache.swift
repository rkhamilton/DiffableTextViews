//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Cache
//*============================================================================*

public final class Cache<Key, Value> where Key: Hashable & AnyObject, Value: AnyObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let nscache: NSCache<Key, Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.nscache = NSCache()
    }

    //=------------------------------------------------------------------------=
    // MARK: Search or Insert
    //=------------------------------------------------------------------------=
    
    @inlinable public func reuseable(_ key: Key, make: @autoclosure () throws -> Value) rethrows -> Value {
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        if let instance = nscache.object(forKey: key) {
            return instance
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = try make()
            nscache.setObject(instance,  forKey: key)
            return instance
        }
    }
}
