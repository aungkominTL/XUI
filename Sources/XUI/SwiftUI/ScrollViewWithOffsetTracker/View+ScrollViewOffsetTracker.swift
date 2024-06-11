//
//  View+ScrollViewOffsetTracker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import Foundation
import SwiftUI

public extension View {
    func scrollViewOffset(
        namespace: String,
        action: @escaping (_ offset: CGPoint) -> Void
    ) -> some View {
        self.coordinateSpace(name: namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}
