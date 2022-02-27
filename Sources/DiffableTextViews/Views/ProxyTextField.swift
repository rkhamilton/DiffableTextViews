//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * ProxyTextField
//*============================================================================*

public final class ProxyTextField {
    public typealias Behavior     = ProxyTextField_Behavior
    public typealias Keyboard  = ProxyTextField_Keyboard
    public typealias Selection = ProxyTextField_Selection
    public typealias Text      = ProxyTextField_Text

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Views
    //=------------------------------------------------------------------------=
    
    @inlinable public var behavior: Behavior {
        Behavior(wrapped)
    }
    
    @inlinable public var keyboard: Keyboard {
        Keyboard(wrapped)
    }
    
    @inlinable public var selection: Selection {
        Selection(wrapped)
    }
    
    @inlinable public var text: Text {
        Text(wrapped)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Actions
    //=------------------------------------------------------------------------=
    
    /// Asks this object to relinquish its status as first responder in its window.
    ///
    /// SwiftUI.FocusState is the preferred focusing mechanism in most cases.
    ///
    @inlinable public func deactivate() {
        Task { @MainActor in wrapped.resignFirstResponder() }
    }
}

#endif
