//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Changes
//*============================================================================*

/// A snapshot and one continuous change not yet applied to it.
public struct Changes {
    public typealias Change<S: Scheme> = (range: Range<Layout<S>.Index>, content: String)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let snapshot:    Snapshot
    public var replacement: Snapshot
    public var range: Range<Snapshot.Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<S>(_ snapshot: Snapshot, change: Change<S>) where S: Scheme {
        self.snapshot = snapshot; self.replacement = Snapshot(change.content, as: .content)
        self.range = change.range.lowerBound.subindex ..< change.range.upperBound.subindex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a new snapshot with proposed changes applied to it.
    @inlinable public func proposal() -> Snapshot {
        var result = snapshot; result.replaceSubrange(range, with: replacement); return result
    }
}
