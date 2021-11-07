//
//  NumericTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumericTextValue

public protocol NumericTextValue: Comparable {
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias NumericTextStyle = NumericTextStyleKit.NumericTextStyle<Self>
    typealias NumericTextPrecision = NumericTextStyleKit.NumericTextPrecision<Self>
    typealias NumericTextSeparator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Values
    
    static var zero:             Self { get }
    static var minLosslessValue: Self { get }
    static var maxLosslessValue: Self { get }
    
    // MARK: Precision
    
    static var maxLosslessDigits:        Int { get }
    static var maxLosslessIntegerDigits: Int { get }
    static var maxLosslessDecimalDigits: Int { get }
    
    // MARK: Utilities
    
    @inlinable static func value(_ components: NumericTextComponents) -> Self?
    @inlinable static func style(_ locale: Locale, precision: NumericTextPrecision.Wrapped, separator: NumericTextSeparator) -> FormatStyle
}

// MARK: - Descriptions

public extension NumericTextValue {
    @inlinable static var float:   Bool { maxLosslessDecimalDigits != 0 }
    @inlinable static var integer: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Implementations: Numeric

public extension NumericTextValue where Self: Numeric {
    @inlinable static var zero: Self { .zero }
}

// MARK: - NumericTextValueAsInteger

public  protocol NumericTextValueAsInteger: NumericTextValue { }
public extension NumericTextValueAsInteger {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - NumericTextValueAsFloat

public  protocol NumericTextValueAsFloat: NumericTextValue { }
public extension NumericTextValueAsFloat {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}

#endif
