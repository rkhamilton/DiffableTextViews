//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import Foundation

#warning("Clean this up.")
//*============================================================================*
// MARK: * DiffableTextStyle
//*============================================================================*

/// A protocol for styles that are capable of as-you-type formatting and conversion.
public protocol DiffableTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    associatedtype Value: Equatable
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Updates the locale, if possible.
    ///
    /// - The locale may be provided by the environment.
    /// - The default implementation returns an unmodified self.
    ///
    @inlinable func locale(_ locale: Locale) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    #warning("Maybe it should throw, dunno.")
    #warning("Throws requires a default value, in case the first value throws.")
    /// Transforms the value.
    ///
    /// - Source: downstream and upstream.
    /// - The default implementation has no effect.
    ///
    @inlinable func autocorrect(value: inout Value)
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// A snapshot of the value according to the mode.
    ///
    /// - Source: upstream.
    ///
    @inlinable func snapshot(value: Value, mode: Mode) -> Snapshot // required (!)
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    /// Merges the current snapshot with the input.
    ///
    /// - Source: downstream.
    ///
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// The value represented by the snapshot.
    ///
    /// - Source: downstream.
    ///
    @inlinable func parse(snapshot: Snapshot) throws -> Value // required (!)
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }

    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=

    @inlinable func autocorrect(value: inout Value) { }

    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value> {
        var result = snapshot
        result.replaceSubrange(input.range, with: input.content)
        return Output(result)
    }
}
