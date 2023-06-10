//
//  HapticsClient.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 4/01/02.
//

import UIKit

public struct HapticsClient {
    public let generateFeedback: (UIImpactFeedbackGenerator.FeedbackStyle) -> Void
    public let generateNotificationFeedback: (UINotificationFeedbackGenerator.FeedbackType) -> Void
}

private extension HapticsClient {
    static let live: Self = .init(
        generateFeedback: { style in
            _Haptics.play(style)
        },
        generateNotificationFeedback: { style in
            _Haptics.generateNotificationFeedback(style: style)
        }
    )
}

private struct HapticsClientProviderKey: InjectionKey {
    static var currentValue: HapticsClient?
}

public extension InjectedValues {
    var hapticsClient: HapticsClient {
        get {
            guard let injected = Self[HapticsClientProviderKey.self] else {
                let new = HapticsClient.live
                HapticsClientProviderKey.currentValue = new
                return new
            }
            return injected
        }
        set { Self[HapticsClientProviderKey.self] = newValue }
    }
}
