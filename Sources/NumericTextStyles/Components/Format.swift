//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import struct Foundation.Locale
import   enum Foundation.NumberFormatStyleConfiguration

// MARK: - Format

@usableFromInline struct Format<Value: NumericTextValue> {
    @usableFromInline typealias Bounds = NumericTextStyles.Bounds<Value>
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties

    @usableFromInline private(set) var locale: Locale
    @usableFromInline private(set) var bounds: Bounds
    @usableFromInline private(set) var precision: Precision
    @usableFromInline private(set) var parser: NumberParser

    // MARK: Initializers
    
    @inlinable init(locale: Locale) {
        self.locale = locale
        self.bounds = .standard
        self.precision = .standard
        self.parser = .standard

        parser.update(locale: locale)
        parser.update(options: Value.options)
    }
    
    // MARK: Transformations
    
    @inlinable mutating func update(locale: Locale) {
        self.locale = locale
        self.parser.update(locale: locale)
    }
    
    @inlinable mutating func update(bounds: Bounds) {
        self.bounds = bounds
    }
    
    @inlinable mutating func update(precision: Precision) {
        self.precision = precision
    }
    
    // MARK: Characters
    
    @inlinable var zero: Character {
        Digits.zero
    }
    
    @inlinable var digits: Set<Character> {
        Digits.decimals
    }
    
    @inlinable var signs: Set<Character> {
        Sign.all
    }
    
    @inlinable var fractionSeparator: String {
        locale.decimalSeparator ?? Separator.dot
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ""
    }
        
    // MARK: Styles
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> Value.FormatStyle {
        let precision: _Format.Precision = precision.editableStyleThatUses(number: number)
        let separator: _Format.Separator = number.separator.isEmpty ? .automatic : .always
        return Value.style(locale: locale, precision: precision, separator: separator)
    }
}

// MARK: - Format: Helpers

@usableFromInline enum _Format {
    @usableFromInline typealias Precision = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
}
