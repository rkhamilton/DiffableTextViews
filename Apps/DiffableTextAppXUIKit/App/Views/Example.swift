//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: * Example
//*============================================================================*

struct Example<Style: DiffableTextStyle>: View {
    typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style: Style
    let value: Binding<Value>
    let description: String
    @FocusState var focus: Bool

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(value: Binding<Value>, style: Style) {
        self.style = style
        self.value = value
        self.description = String(describing: value.wrappedValue)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var placeholder: String {
        "Much wow. Such empty."
    }
    
    var secondary: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    var tertiary: Color {
        Color(uiColor:  .tertiarySystemBackground)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack {
            descriptionText
            diffableTextField
        }
        .padding()
        .background(secondary)
        .onTapGesture{ focus.toggle() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var descriptionText: some View {
        Text(!description.isEmpty ? description : " ")
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .border(tertiary, width: 2)
            .background(secondary)
    }
    
    var diffableTextField: some View {
        DiffableTextField(placeholder, value: value, style: style)
            .focused($focus)
            .padding()
            .background(tertiary)
            .diffableTextViews_font(.body.monospaced())
            .diffableTextViews_inputAccessory {
                HStack {
                    // commented code demonstrates a more complete input accessory
//                    Button("\(Image(systemName: "chevron.left"))") {
//                        print("focus on previous element")
//                    }
//                    .padding()
//                    Button("\(Image(systemName: "chevron.right"))") {
//                        print("focus on next element")
//                    }
//                    .padding()
//                    Spacer()
//                    Button("clear") {
//                        print("clear bound value")
//                    }
//                    .padding()
                    Spacer()
                    Button {
                        focus = false
                    } label: {
                        Label("dismiss keyboard", systemImage: "keyboard.chevron.compact.down")
                            .labelStyle(.iconOnly)
                    }
                    .padding()
                }
            }
    }
}
