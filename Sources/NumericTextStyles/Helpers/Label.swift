//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import DiffableTextViews
import Support

#warning("...")
#warning("...")
#warning("Rename as label and create a new currency specialization, maybe.")
//*============================================================================*
// MARK: * Label
//*============================================================================*

#warning("Currenc")
public final class Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    #warning("Label cache should not be here.")
    @usableFromInline static let cache: NSCache<ID, Label> = {
        let cache = NSCache<ID, Label>(); cache.countLimit = 33; return cache
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let characters: String
    @usableFromInline let location: Location
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S: StringProtocol>(_ characters: S, at location: Location) {
        self.location = location
        self.characters = String(characters)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*
    
    @usableFromInline final class ID: Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let code:   String
        @usableFromInline let locale: String
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(code: String, locale: String) {
            self.code = code
            self.locale = locale
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Hashable
        //=--------------------------------------------------------------------=
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(code)
            hasher.combine(locale)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: ID, rhs: ID) -> Bool {
            lhs.code == rhs.code && lhs.locale == rhs.locale
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Indirect
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("Double-check.")
    @inlinable convenience init(code: String, in region: Region) {
        let digit = region.digits[.zero]
        //=--------------------------------------=
        // MARK: Split
        //=--------------------------------------=
        let split = IntegerFormatStyle<Int>
            .Currency(code: code).locale(region.locale)
            .precision(.fractionLength(0)).format(0)
            .split(separator: digit, omittingEmptySubsequences: false)
        //=--------------------------------------=
        // MARK: Check
        //=--------------------------------------=
        guard split.count == 2 else {
            fatalError(Info([.mark(digit), "is not in", .mark(split)]).description)
        }
        //=--------------------------------------=
        // MARK: Instance
        //=--------------------------------------=
        #warning("Double-check.")
        if !split[0].filter(\.isWhitespace).isEmpty {
            self.init(split[0], at: .prefix)
        } else {
            self.init(split[1], at: .suffix)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Label {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func cached(code: String, in region: Region) -> Currency {
        let key = ID(code: code, locale: region.locale.identifier)
        //=--------------------------------------=
        // MARK: Search In Cache
        //=--------------------------------------=
        if let reusable = cache.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = Currency(code: code, in: region)
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Autocorrect
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(snapshot: inout Snapshot) {
        guard !characters.isEmpty else { return }
        guard let range = range(in: snapshot) else { return }
        snapshot.update(attributes: range) { attribute in attribute = .phantom }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are close to the edge and unique from edge to end.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
}
