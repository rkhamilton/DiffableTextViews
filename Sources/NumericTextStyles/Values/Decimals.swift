//
//  Decimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Decimal
import struct Foundation.Locale

// MARK: - Decimal

extension Decimal: Valuable, PreciseFloatingPoint {
    
    // MARK: Valuable
    
    public static let options: Options = .floatingPoint

    // MARK: Precise
 
    public static let maxLosslessSignificantDigits: Int = 38
    
    // MARK: Boundable
        
    @inlinable public static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Self {  maxLosslessLimit }
    @usableFromInline static let maxLosslessLimit: Self = {
        Decimal(string: String(repeating: "9", count: maxLosslessSignificantDigits))!
    }()

    // MARK: Formattable
    
    @inlinable public static func make(description: String) -> Optional<Self> {
        .init(string: description)
    }
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
