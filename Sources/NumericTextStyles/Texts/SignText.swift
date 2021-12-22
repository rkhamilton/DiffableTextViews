//
//  SignText.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - SignText

public enum SignText: String, Text {
    
    // MARK: Cases
    
    case none = ""
    case positive = "+"
    case negative = "-"
    
    // MARK: Initializers
    
    @inlinable public init() {
        self = .none
    }
        
    // MARK: Getters
    
    @inlinable @inline(__always) public var isEmpty: Bool {
        rawValue.isEmpty
    }
    
    @inlinable @inline(__always) public var characters: String {
        rawValue
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let all = Set<Character>(["+", "-"])
}
