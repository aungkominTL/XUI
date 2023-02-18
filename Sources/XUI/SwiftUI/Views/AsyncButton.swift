//
//  AsyncButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/1/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct _AsyncButton<Label: View>: View {

    var actionOptions = Set(ActionOption.allCases)
    let action: (@Sendable () async throws  -> Void)
    var onFinish: (@Sendable @MainActor () -> Void)?
    var onError: (@Sendable @MainActor (Error) -> Void)?
    @ViewBuilder var label: () -> Label

    private var delay: Double = 0.2
    @State private var isDisabled = false
    @State private var showProgressView = false
    @State private var errrorAlert: _Alert?

    public init(actionOptions: Set<ActionOption> = Set(ActionOption.allCases), action: @escaping (@Sendable () async throws  -> Void), label: @escaping () -> Label, onFinish: (@Sendable @MainActor () -> Void)? = nil, onError: (@Sendable @MainActor (Error) -> Void)? = nil) {
        self.actionOptions = actionOptions
        self.action = action
        self.label = label
        self.onFinish = onFinish
        self.onError = onError
        self.isDisabled = isDisabled
        self.showProgressView = showProgressView
        self.errrorAlert = errrorAlert
    }

    public var body: some View {
        Button {
            _Haptics.shared.play(.soft)
            if actionOptions.contains(.disableButton) {
                isDisabled = true
            }
            Task {
                var progressViewTask: Task<Void, Error>?

                if actionOptions.contains(.showProgressView) {
                    progressViewTask = Task {
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
                    handleFinish()
                } catch {
                    progressViewTask?.cancel()
                    showProgressView = false
                    isDisabled = false
                    try await Task.sleep(for: .seconds(delay))
                    handleError(error)
                }
            }
        } label: {
            ZStack {
                label()
                    .opacity(showProgressView ? 0 : 1)
                if showProgressView {
                    ProgressView()
                }
            }
        }
        .disabled(isDisabled)
        .buttonStyle(.borderless)
        ._alert($errrorAlert)
    }

    @MainActor
    private func handleError(_ error: Error) {
        if let onError {
            _Haptics.shared.notify(.error)
            errrorAlert = .init(title: "Error", message: error.localizedDescription) {
                _Haptics.shared.play(.light)
                onError(error)
            }
        }
    }
    @MainActor
    private func handleFinish() {
        if let onFinish {
            if actionOptions.contains(.showFinishAlert) {
                _Haptics.shared.notify(.success)
                errrorAlert = .init(title: "Success") {
                    _Haptics.shared.play(.light)
                    onFinish()
                }
            } else {
                onFinish()
            }
        }
    }
}

@available(iOS 16.0, *)
public extension _AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
        case showFinishAlert
    }
}
