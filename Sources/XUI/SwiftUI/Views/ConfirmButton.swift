//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI
@available(iOS 16.0, *)
public struct _ConfirmButton<Content: View>: View {

    private let title: String
    private let action: () -> Void
    private var label: () -> Content

    public init(title: String, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.title = title
        self.action = action
        self.label = label
    }
    @State private var isShown = false

    public var body: some View {
        Button {
            isShown = true
        } label: {
            label()
        }
        .confirmationDialog("Dialog", isPresented: $isShown, actions: {
            Button(role: .destructive, action: onConfirm) {
                Text("Continue \(title)")
            }
        }, message: {
            Text("Comfirm to \(title)?")
        })
        .labelsHidden()
    }
    private func onConfirm() {
        _Haptics.shared.play(.light)
        action()
    }
}
