//
//  BorderedProminentButton.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct BorderedProminentButton<Content: View>: View {
    
    let action: () -> Void
    @ViewBuilder var label: () -> Content

    var body: some View {
        AsyncButton {
            action()
        } label: {
            label()
                ._borderedProminentButtonStyle()
        }
    }
}

