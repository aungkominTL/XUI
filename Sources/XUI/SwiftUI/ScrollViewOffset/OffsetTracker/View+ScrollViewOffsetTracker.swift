//
//  View+ScrollViewOffsetTracker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import Foundation
import SwiftUI

public extension View {
    /**
     Add this modifier to any `ScrollView`, `List` or custom
     view that uses ``ScrollViewOffsetTracker`` to track its
     scroll offset.
     */
    func withScrollOffsetTracking(
        action: @escaping (_ offset: CGPoint) -> Void
    ) -> some View {
        self.coordinateSpace(name: ScrollOffsetNamespace.namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}
