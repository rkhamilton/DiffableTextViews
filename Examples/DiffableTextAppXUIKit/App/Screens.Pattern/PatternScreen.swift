//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct PatternScreen: View {
    typealias Context = PatternScreenContext

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @StateObject var context = Context()

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Screen {
            Scroller {
                Segments(context.kind.xwrapped)
                
                PatternScreenVisibilityToggle(visible: context.visible)
                
                PatternScreenActionsStack(context)
                
                Spacer()
            }
            
            Divider()
            
            PatternScreenExample(context)
        }
    }
}

//*============================================================================*
// MARK: Previews
//*============================================================================*

struct PatternTextStyleScreenPreviews: PreviewProvider {
    static var previews: some View {
        PatternScreen().preferredColorScheme(.dark)
    }
}
