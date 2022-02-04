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
// MARK: * Localizer
//*============================================================================*

#warning("Remove and replace with generic.")
struct Localizer: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let locales: [Locale]
    let selection: Binding<Locale>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ selection: Binding<Locale>, in locales: [Locale]) {
        self.locales = locales
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker("Locales", selection: selection) {
            ForEach(locales, id: \.self) { locale in
                Text(locale.identifier).tag(locale)
            }
        }
        .pickerStyle(.wheel)
    }
}

