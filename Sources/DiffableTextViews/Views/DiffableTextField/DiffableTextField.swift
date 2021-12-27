//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI
import protocol Utilities.Transformable

// MARK: - DiffableTextField

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable, Transformable {
    public typealias Value = Style.Value
    public typealias UIViewType = BasicTextField
    public typealias Configuration = (ProxyTextField) -> Void
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    @usableFromInline var setup:  Configuration? = nil
    @usableFromInline var update: Configuration? = nil
    @usableFromInline var submit: Configuration? = nil

    // MARK: Initializers
    
    @inlinable public init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }

    // MARK: Transformations
    
    @inlinable public func setup(_ setup: Configuration?) -> Self {
        transforming({ $0.setup = setup })
    }
    
    @inlinable public func update(_ update: Configuration?) -> Self {
        transforming({ $0.update = update })
    }
    
    @inlinable public func submit(_ submit: Configuration?) -> Self {
        transforming({ $0.submit = submit })
    }

    // MARK: UIViewRepresentable
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Context) -> UIViewType {
        let uiView = BasicTextField()
        
        // --------------------------------- //
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // --------------------------------- //
        
        context.coordinator.connect(uiView)
        setup?(context.coordinator.downstream)
        
        // --------------------------------- //

        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.upstream = self
        update?(context.coordinator.downstream)
        context.coordinator.synchronize(update: .async)
    }
    
    // MARK: Coordinator
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
        @usableFromInline typealias Cache = DiffableTextViews.Cache<UTF16, Value>
        
        // MARK: Properties
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        // MARK: Properties: Helpers
        
        @usableFromInline let lock  =  Lock()
        @usableFromInline let cache = Cache()
        
        // MARK: Initializers: Setup

        @inlinable func connect(_ uiView: UIViewType) {
            uiView.delegate = self            
            self.downstream = ProxyTextField(uiView)
        }
        
        // MARK: Delegate: Submit
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.submit?(downstream) == nil ? true : false
        }
        
        // MARK: Delegate: Mode
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        // MARK: Delegate: Input
        
        @inlinable public func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString string: String) -> Bool {
            do {
                
                let offsets = Offset(at: nsRange.lowerBound) ..< Offset(at: nsRange.upperBound)
                let range = cache.field.indices(at: offsets)
                let input = Snapshot(string, only: .content)
                
                let indices = range.lowerBound.rhs! ..< range.upperBound.rhs!
                var snapshot = try upstream.style.merge(snapshot: cache.snapshot, with: input, in: indices)
                upstream.style.process(snapshot: &snapshot)
                
                var value = try upstream.style.parse(snapshot: snapshot)
                upstream.style.process(value: &value)
                
                let field = cache.field.updating(selection: range.upperBound, intent: nil).updating(carets: snapshot)
                                
                Task { @MainActor [value] in
                    // async to process special commands first
                    self.cache.value = value
                    self.cache.field = field
                    self.push(update: [.upstream, .downstream])
                }
                
            } catch let reason {
                #if DEBUG
                
                print("User input cancelled: \(reason)")
                
                #endif
            }
            
            return false
        }
        
        // MARK: Delegate: Selection
        
        @inlinable public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard !lock.isLocked else { return }

            // --------------------------------- //
            
            let selection = downstream.selection()
            let field = cache.field.updating(selection: selection, intent: downstream.intent)
            let synchronized = field.selection.offsets == selection
            
            // --------------------------------- //
            
            self.cache.field = field
            if !synchronized {
                lock.perform {
                    self.downstream.update(selection: field.selection.offsets)
                }
            }
        }

        // MARK: Synchronize
        
        @inlinable func synchronize(update: Update = []) {
            push(update: pull().union(update))
        }
        
        // MARK: Synchronize: Pull
        
        @inlinable func pull() -> Update {
            var update: Update = []
            
            // --------------------------------- //
            
            var value = upstream.value.wrappedValue
            upstream.style.process(value: &value)
            
            // --------------------------------- //
        
            if !upstream(represents: value) {
                update.insert(.upstream)
            }
         
            // --------------------------------- //
            
            if !downstream(displays: value) {
                update.insert(.downstream)

                // --------------------------------- //
                
                var snapshot = snapshot(value: value)
                upstream.style.process(snapshot: &snapshot)
                let field = cache.field.updating(carets: snapshot)
                                
                // --------------------------------- //
                
                self.cache.value = value
                self.cache.field = field
            }
            
            // --------------------------------- //
                
            return update
        }
        
        // MARK: Synchronize: Push
        
        @inlinable func push(update: Update) {
            if update.contains(.downstream) {
                lock.perform {
                    // changes to UITextField's text and selection both call
                    // the delegate's method: textFieldDidChangeSelection(_:)
                    self.downstream.update(text: cache.snapshot.characters)
                    self.downstream.update(selection: cache.field.selection.offsets)
                }
                            
                self.cache.edits = self.downstream.edits
            }
            
            if update.contains(.upstream) {
                perform(async: update.contains(.async)) {
                    // async avoids view update loop
                    if  self.upstream.value.wrappedValue != self.cache.value {
                        self.upstream.value.wrappedValue  = self.cache.value
                    }
                }
            }
        }
        
        // MARK: Synchronize: Status

        @inlinable func upstream(represents value: Value) -> Bool {
            upstream.value.wrappedValue == value
        }
        
        @inlinable func downstream(displays value: Value) -> Bool {
           cache.edits == downstream.edits && cache.value == value
        }
        
        // MARK: Synchronize: Helpers
        
        @inlinable func perform(async: Bool, action: @escaping () -> Void) {
            if async { Task { @MainActor in action() } } else { action() }
        }

        @inlinable func snapshot(value: Value) -> Snapshot {
            downstream.edits ? upstream.style.snapshot(editable: value) : upstream.style.snapshot(showcase: value)
        }
    }
}

#endif
