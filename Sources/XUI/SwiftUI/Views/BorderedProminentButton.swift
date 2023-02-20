//
//  BorderedProminentButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct BorderedProminentButton<Content: View>: View {
    
    let action: () -> Void
    @ViewBuilder var label: () -> Content

    public init(action: @escaping () -> Void, label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        AsyncButton {
            action()
        } label: {
            label()
                ._borderedProminentButtonStyle()
        }
    }
}

