//
//  AsyncButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/1/23.
//

import SwiftUI
public typealias AsyncAction = (@MainActor @Sendable() async throws -> Void)

public struct AsyncButton<Label: View>: View {
    
    var actionOptions = Set(ActionOption.allCases)
    let action: AsyncAction
    var onFinish: AsyncAction?
    var onError: ((Error) -> Void)?
    
    @ViewBuilder var label: () -> Label
    
    private var delay: Double = 0.2
    @State private var isDisabled = false
    @State private var showProgressView = false
    
    public init(
        actionOptions: Set<ActionOption> = [.disableButton],
        action: @escaping AsyncAction,
        label: @escaping () -> Label,
        onFinish: AsyncAction? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        self.actionOptions = actionOptions
        self.action = action
        self.label = label
        self.onFinish = onFinish
        self.onError = onError
        self.isDisabled = isDisabled
        self.showProgressView = showProgressView
    }
    
    @State private var debouncedTask: Task<Void, Never>?
    
    public var body: some View {
        Button {
            debouncedTask?.cancel()
            debouncedTask = Task { @MainActor in
                if Task.isCancelled { return }
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }
                var progressViewTask: Task<Void, Error>?
                if actionOptions.contains(.showProgressView) {
                    progressViewTask = Task { @MainActor in
                        if Task.isCancelled { return }
                        showProgressView = true
                    }
                }
                do {
                    if Task.isCancelled { return }
                    _Haptics.play(.light)
                    try await action()
                    progressViewTask?.cancel()
                    if actionOptions.contains(.showProgressView) {
                        showProgressView = false
                    }
                    if actionOptions.contains(.disableButton) {
                        isDisabled = false
                    }
                    if let onFinish {
                        if Task.isCancelled { return }
                        try await onFinish()
                    }
                } catch {
                    progressViewTask?.cancel()
                    showProgressView = false
                    isDisabled = false
                    onError?(error)
                }
            }
        } label: {
            label()
                .opacity(showProgressView ? 0.3 : isDisabled ? 0.3 : 1)
                .overlay {
                    if showProgressView {
                        ProgressView()
                    }
                }
        }
        .disabled(isDisabled)
    }
}

public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}
