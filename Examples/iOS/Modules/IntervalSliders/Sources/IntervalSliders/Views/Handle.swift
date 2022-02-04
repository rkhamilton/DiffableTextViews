//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Handle
//*============================================================================*

@usableFromInline struct Handle: View, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: CGFloat
    @usableFromInline let value: Binding<CGFloat>
    @usableFromInline let storage: Storage

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, value: Binding<CGFloat>, position: CGFloat) {
        self.value = value
        self.position = position
        self.storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        shape
            .fill(.white)
            .overlay(shape.fill(Material.thin))
            .overlay(shape.strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .highPriorityGesture(drag)
            .position(x: position, y: frame.midY)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @inlinable var shape: some InsettableShape {
        Circle()
    }

    @inlinable var drag: some Gesture {
        DragGesture(coordinateSpace: .named(coordinates)).onChanged { gesture in
            withAnimation(slide) {
                value.wrappedValue = map(gesture.location.x, from: positionsLimits, to: valuesLimits)
            }
        }
    }
}
