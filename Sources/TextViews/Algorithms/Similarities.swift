//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: - Similarities

#warning("Make common method for lhsPrefix and rhsPrefix.")
@usableFromInline struct Similarities<LHS: Collection, RHS: Collection> where LHS.Element == RHS.Element {
    @usableFromInline typealias Element = LHS.Element
    @usableFromInline typealias Options = SimilaritiesOptions<Element>
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    
    // MARK: Properties
    
    @usableFromInline let lhs: LHS
    @usableFromInline let rhs: RHS
    @usableFromInline let options: Options
    
    // MARK: Initializers
    
    @inlinable init(lhs: LHS, rhs: RHS, options: Options) {
        self.lhs = lhs
        self.rhs = rhs
        self.options = options
    }
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options) {
        self.init(lhs: lhs, rhs: rhs, options: options)
    }
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options = .defaults()) where Element: Equatable {
        self.init(lhs: lhs, rhs: rhs, options: options)
    }
    
    // MARK: Maps
    
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    // MARK: Methods
    
    @usableFromInline func lhsPrefix() -> LHS.SubSequence {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        
        // --------------------------------- //
        
        while let nextLhsIndex = lhs[lhsIndex...].firstIndex(where: options.inspection.includes),
              let nextRhsIndex = rhs[rhsIndex...].firstIndex(where: options.inspection.includes) {
            
            // --------------------------------- //
            
            let instruction = options.comparison.instruction(lhs[nextLhsIndex], rhs[nextRhsIndex])

            // --------------------------------- //
            
            guard instruction.isEmpty else { break }
            
            // --------------------------------- //
            
            if instruction.contains(.nextLHS) {
                lhsIndex = lhs.index(after: nextLhsIndex)
            }
            
            if instruction.contains(.nextRHS) {
                rhsIndex = rhs.index(after: nextRhsIndex)
            }
        }
        
        // --------------------------------- //
        
        if options.production == .overshoot {
            lhsIndex = lhs[lhsIndex...].firstIndex(where: options.inspection.includes) ?? lhs.endIndex
        }
        
        // --------------------------------- //
        
        return lhs[..<lhsIndex]
    }
    
    @inlinable func rhsPrefix() -> RHS.SubSequence {
        make(rhs, lhs).lhsPrefix()
    }
    
    @inlinable func lhsSuffix() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = make(lhs.reversed(), rhs.reversed()).lhsPrefix()
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    @inlinable func rhsSuffix() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        make(rhs, lhs).lhsSuffix()
    }
}

// MARK: - Comparison

#warning("If skipLHS & skipRHS is used, then rhsPrefix cannot invert itself like it does.")
#warning("Instead a common method must be made and used by both.")

@usableFromInline struct SimilaritiesInstruction: OptionSet {
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    // MARK: Options
    
    @usableFromInline static let nextLHS = Self(rawValue: 1 << 0)
    @usableFromInline static let nextRHS = Self(rawValue: 1 << 1)
    
    @usableFromInline static let next = Self([.nextLHS, .nextRHS])
    @usableFromInline static let done = Self([])
}
            
// MARK: - Collection

extension Collection {
    
    // MARK: Prefix
    
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }

    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }
}

// MARK: - BidirectionalCollection
            
extension BidirectionalCollection {
    
    // MARK: Suffix
    
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }

    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }
}

// MARK: -

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline typealias Comparison = SimilaritiesOptionsComparison<Element>
    @usableFromInline typealias Inspection = SimilaritiesOptionsInspection<Element>
    @usableFromInline typealias Production = SimilaritiesOptionsProduction
    
    // MARK: Storage
    
    @usableFromInline var comparison: Comparison
    @usableFromInline var inspection: Inspection
    @usableFromInline var production: Production

    // MARK: Initializers

    @inlinable init(comparison: Comparison, inspection: Inspection = .defaultValue, production: Production = .defaultValue) {
        self.comparison = comparison
        self.inspection = inspection
        self.production = production
    }
    
    @inlinable init(comparison: Comparison = .equation(==), inspection: Inspection = .defaultValue, production: Production = .defaultValue) where Element: Equatable {
        self.comparison = comparison
        self.inspection = inspection
        self.production = production
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func compare(_ comparison: Comparison) -> Self {
        Self(comparison: comparison)
    }
    
    @inlinable static func inspect(_ inspection: Inspection) -> Self where Element: Equatable {
        Self(inspection: inspection)
    }

    @inlinable static func produce(_ production: Production) -> Self where Element: Equatable {
        Self(production: production)
    }
    
    @inlinable static func defaults() -> Self where Element: Equatable {
        Self(comparison: .equation(==))
    }
    
    // MARK: Transformations
    
    @inlinable func compare(_ comparison: Comparison) -> Self {
        copy(assign: comparison, to: \.comparison)
    }
        
    @inlinable func inspect(_ inspection: Inspection) -> Self {
        copy(assign: inspection, to: \.inspection)
    }
    
    @inlinable func produce(_ production: Production) -> Self {
        copy(assign: production, to: \.production)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func copy<Value>(assign newValue: Value, to keyPath: WritableKeyPath<Self, Value>) -> Self {
        var copy = self; copy[keyPath: keyPath] = newValue; return copy
    }
}

// MARK: - Options: Comparison

@usableFromInline struct SimilaritiesOptionsComparison<Element> {
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    
    // MARK: Properties
    
    @usableFromInline let instruction: (Element, Element) -> Instruction
    
    // MARK: Initializers
    
    @inlinable init(_ instruction: @escaping (Element, Element) -> Instruction) {
        self.instruction = instruction
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func instruction(_ instruction: @escaping (Element, Element) -> Instruction) -> Self {
        Self(instruction)
    }
    
    @inlinable static func equation(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        Self({ equivalent($0, $1) ? .next : .done })
    }
    
    @inlinable static func equatable<Value: Equatable>(_ value: @escaping (Element) -> Value) -> Self {
        Self({ value($0) == value($1) ? .next : .done })
    }
}


// MARK: - Options: Inspection

@usableFromInline struct SimilaritiesOptionsInspection<Element> {
    @usableFromInline let includes: (Element) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(includes: @escaping (Element) -> Bool) {
        self.includes = includes
    }
    
    // MARK: Initializers: Static

    @inlinable static var each: Self {
        Self(includes: { _ in true })
    }
    
    @inlinable static func only(_ includes: @escaping (Element) -> Bool) -> Self {
        Self(includes: includes)
    }
    
    @inlinable static var defaultValue: Self { .each }
}

// MARK: - Options: Production

@usableFromInline enum SimilaritiesOptionsProduction {
    case wrapper
    case overshoot
    
    // MARK: Initializers: Static
    
    @inlinable static var defaultValue: Self { .wrapper }
}
