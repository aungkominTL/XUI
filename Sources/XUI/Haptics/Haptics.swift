//
//  Haptics.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 8/2/23.
//

import UIKit

public class Haptics {

    public static var shared: Haptics {
        get { _shared }
        set { _shared = newValue }
    }
    @AtomicQueue
    private static var _shared = Haptics()

    private init() { }

    public func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

    public func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
