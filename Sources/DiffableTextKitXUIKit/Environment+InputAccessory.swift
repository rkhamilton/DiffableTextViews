//
//  Environment+InputAccessory.swift
//  DiffableTextFieldEvaluation
//
//  Created by Ryan Hamilton on 4/14/23.
//

import SwiftUI

// MARK: - Keys
private struct DiffableTextViews_InputAccessory: EnvironmentKey {
    static let defaultValue: UIView? = nil
}

// MARK: - Input Accessory
extension EnvironmentValues {
    ///. The input accessory view for a `DiffableTextField`.
    public var diffableTextViews_InputAccessory: UIView? {
        get { self[DiffableTextViews_InputAccessory.self] }
        set { self[DiffableTextViews_InputAccessory.self] = newValue }
    }
}

extension View {
    /// Set the environment value of `DiffableTextViews_InputAccessory`.
    @inlinable public func diffableTextViews_inputAccessory<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        let controller = UIHostingController(rootView: content())
        let view = controller.view
        
        return environment(\.diffableTextViews_InputAccessory, view)
    }
}



