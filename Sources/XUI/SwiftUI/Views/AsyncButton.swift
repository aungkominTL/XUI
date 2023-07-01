//
//  AsyncButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/1/23.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {

    public typealias AsyncAction = (@MainActor @Sendable() async throws -> Void)
    var actionOptions = Set(ActionOption.allCases)
    let action: AsyncAction
    var onFinish: AsyncAction?
    var onError: ((Error) -> Void)?

    @ViewBuilder var label: () -> Label

    private var delay: Double = 0.2
    @State private var isDisabled = false
    @State private var showProgressView = false

    public init(actionOptions: Set<ActionOption> = [.disableButton], action: @escaping AsyncAction, label: @escaping () -> Label, onFinish: AsyncAction? = nil, onError: ((Error) -> Void)? = nil) {
        self.actionOptions = actionOptions
        self.action = action
        self.label = label
        self.onFinish = onFinish
        self.onError = onError
        self.isDisabled = isDisabled
        self.showProgressView = showProgressView
    }

    public var body: some View {
        Button {
            Task {
                _Haptics.play(.light)
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }
                var progressViewTask: Task<Void, Error>?
                if actionOptions.contains(.showProgressView) {
                    progressViewTask = Task { @MainActor in
                        if Task.isCancelled { return }
                        showProgressView = true
                    }
                    try await Task.sleep(for: .seconds(delay))
                }
                do {
                    try await action()
                    progressViewTask?.cancel()
                    showProgressView = false
                    isDisabled = false
                    try await Task.sleep(for: .seconds(delay))
                    try await onFinish?()
                } catch {
                    progressViewTask?.cancel()
                    showProgressView = false
                    isDisabled = false
                    onError?(error)
                }
            }
        } label: {
            label()
                .opacity(showProgressView ? 0.1 : 1)
                .overlay {
                    if showProgressView {
                        LoadingIndicator(size: 25)
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
