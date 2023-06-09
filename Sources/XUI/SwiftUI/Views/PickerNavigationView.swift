//
//  PickerNavigationView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 25/3/22.
//

import SwiftUI

public struct _PickerNavigationView<Content: View>: View {
    
    private let canCancel: Bool
    private let content: () -> Content

    public init(canCancel: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.canCancel = canCancel
        self.content = content
    }
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        NavigationStack {
            content()
                .navigationBarItems(leading: Leading())
        }
    }

    @ViewBuilder
    private func Leading() -> some View {
        if canCancel {
            Button("Cancel") { dismiss() }
        }
    }
}
