//
//  TaskOnce.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import SwiftUI

private struct TaskOnceModifier<T: Equatable & Sendable>: ViewModifier {
    typealias Values = (T, T)
    private let id: T
    private let priority: TaskPriority
    private let action: @Sendable (Values) async -> Void
    
    @State private var task: Task<Void, Never>?
    @State private var isFirstTime = true
    
    init(
        id: T,
        priority: TaskPriority = .userInitiated,
        action: @escaping @Sendable (Values) async -> Void
    ) {
        self.id = id
        self.priority = priority
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                guard isFirstTime else { return }
                isFirstTime = false
                self.task = Task(priority: priority) {
                    await action((id, id))
                }
            }
            .onDisappear {
                self.task?.cancel()
                self.task = nil
            }
            .onChange(of: self.id, debounceTime: 0.1) { values in
                self.task?.cancel()
                self.task = Task(priority: priority) {
                    await action(values)
                }
            }
    }
}

public extension View {
    func taskOnce<T: Equatable & Sendable>(id: T, priority: TaskPriority = .high, _ action: @escaping @Sendable ((T, T)) async -> Void) -> some View {
        ModifiedContent(content: self, modifier: TaskOnceModifier(id: id, priority: priority, action: action))
    }
}
