//
//  UInts.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - UInt

extension UInt: NumericTextUInt {
    
    // MARK: Implementation
        
    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    public static let maxLosslessValue: UInt = UInt(Int.maxLosslessValue)

    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    public static let maxLosslessSignificantDigits: Int = Int.maxLosslessSignificantDigits
}

// MARK: - UInt8

extension UInt8: NumericTextUInt {
    
    // MARK: Implementation

    public static let maxLosslessSignificantDigits: Int = 3
}

// MARK: - UInt16

extension UInt16: NumericTextUInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 5
}

// MARK: - UInt32

extension UInt32: NumericTextUInt {
    
    // MARK: Implementation
    
    public static let maxLosslessSignificantDigits: Int = 10
}

// MARK: - UInt64

extension UInt64: NumericTextUInt {
    
    // MARK: Implementation
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    public static let maxLosslessValue: UInt64 = UInt64(Int64.maxLosslessValue)

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    public static let maxLosslessSignificantDigits: Int = Int64.maxLosslessSignificantDigits
}
