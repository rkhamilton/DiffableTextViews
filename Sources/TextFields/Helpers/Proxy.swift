//
//  Proxy.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import UIKit

@usableFromInline final class Proxy {
    @usableFromInline typealias Offset = TextFields.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let uiTextField: UITextField
    
    // MARK: Initializers
    
    @inlinable init(_ uiTextField: UITextField) {
        self.uiTextField = uiTextField
    }
    
    // MARK: Getters
    
    @inlinable var edits: Bool {
        uiTextField.isEditing
    }
    
    // MARK: Text
    
    @inlinable var text: String {
        uiTextField.text!
    }
    
    @inlinable func write(_ text: String) {
        uiTextField.text = text
    }
    
    // MARK: Selection
    
    @inlinable func selection() -> Range<Offset>? {
        uiTextField.selectedTextRange.map(offsets)
    }
    
    @inlinable func select(_ offsets: Range<Offset>) {
        uiTextField.selectedTextRange = positions(of: offsets)
    }
    
    // MARK: Helpers: Range & Offset

    /// - Complexity: O(1).
    @inlinable func offsets(in bounds: UITextRange) -> Range<Offset> {
        offset(at: bounds.start) ..< offset(at: bounds.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Offset {
        .init(at: uiTextField.offset(from: uiTextField.beginningOfDocument, to: position))
    }
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Offset) -> UITextPosition {
        uiTextField.position(from: uiTextField.beginningOfDocument, offset: offset.distance)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(of offsets: Range<Offset>) -> UITextRange {
        uiTextField.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
}
