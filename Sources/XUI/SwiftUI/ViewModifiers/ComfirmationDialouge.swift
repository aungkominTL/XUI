//
//  presentDialogs.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI

@available(iOS 16.0, *)
private struct XDialogModifier<DialogContent: View>: ViewModifier {
    let title: String
    let message: String
    @ViewBuilder var dialogContent: (() -> DialogContent)
    @State private var isShown = false

    public func body(content: Content) -> some View {
        Button {
            isShown = true
        } label: {
            content
                .confirmationDialog(title, isPresented: $isShown) {
                    dialogContent()
                } message: {
                    Text(message)
                }
        }
    }
}

@available(iOS 16.0, *)
public extension View {
    func _comfirmationDialouge<Content: View>(_ title: String = "Attention", message: String = "", @ViewBuilder _ content: @escaping () -> Content) -> some View {
        ModifiedContent(content: self, modifier: XDialogModifier(title: title, message: message, dialogContent: content))
    }
}
