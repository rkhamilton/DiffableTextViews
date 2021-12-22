//
//  NumberTextFloatingPointParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - NumberTextFloatingPointParser

public struct NumberTextFloatingPointParser: NumberTextParser {
    public typealias Output = NumberText
    
    // MARK: Properties
    
    public let sign: SignTextParser
    public let digits: DigitsTextParser
    public let separator: SeparatorTextParser
    
    // MARK: Initializers
    
    @inlinable init(sign: SignTextParser, digits: DigitsTextParser, separator: SeparatorTextParser) {
        self.sign = sign
        self.digits = digits
        self.separator = separator
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        .init(sign: sign.locale(locale), digits: digits.locale(locale), separator: separator.locale(locale))
    }

    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        sign.parse(characters: characters, index: &index, storage: &storage.sign)
        
        // --------------------------------- //
        
        digits.parse(characters: characters, index: &index, storage: &storage.integer)
        guard !storage.integer.isEmpty else { return }
        
        // --------------------------------- //
        
        separator.parse(characters: characters, index: &index, storage: &storage.separator)
        guard !storage.separator.isEmpty else { return }

        // --------------------------------- //
        
        digits.parse(characters: characters, index: &index, storage: &storage.fraction)
    }
    
    // MARK: Instances
    
    public static let standard = Self(sign: .standard, digits: .standard, separator: .standard)
}
