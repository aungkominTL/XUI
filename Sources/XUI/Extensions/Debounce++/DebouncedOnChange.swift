//
//  DebouncedOnChange.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 2/6/24.
//
import SwiftUI

private struct DebouncedOnChangeViewModifier<Value>: ViewModifier where Value: Equatable {
    let value: Value
    let action: @Sendable (Value) async -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: value) { _, value in
            debouncedTask?.cancel()
            debouncedTask = Task {
                do { try await sleep() } catch { return }
                await action(value)
            }
        }
    }
}
extension View {
    public func onChange<Value>(
        of value: Value,
        debounceTime: Duration,
        perform action: @Sendable @escaping (_ newValue: Value) async -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedOnChangeViewModifier(value: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }
    public func onChange<Value>(
        of value: Value,
        debounceTime: TimeInterval,
        perform action: @Sendable @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedOnChangeViewModifier(value: value, action: action) {
            try await Task.sleep(seconds: debounceTime)
        })
    }
}
