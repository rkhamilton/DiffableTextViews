//
//  NumericTextSchemeDecimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - Decimal

/// - Supports up to 38 significant digits.
extension Decimal { }
extension Decimal {
    
    // MARK: Bounds
        
    @usableFromInline static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    
    @inlinable static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precision
 
    @inlinable static var maxLosslessDigits: Int { 38 }
    
    // MARK: Utilities

    @inlinable static func value(_ components: Components) -> Self? {
        .init(string: components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: FormatSubject.Precision, separator: FormatSubject.Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

#endif

