//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI

public struct _ConfirmButton<Content: View>: View {
    
    private let message: String
    private let action: () -> Void
    private let label: () -> Content
    
    public init(_ message: String, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.message = message
        self.action = action
        self.label = label
    }
    @State private var isShown = false
    
    public var body: some View {
        label()
            ._comfirmationDialouge("Attention", message: "Comfirm to \(message)") {
                Button(role: .none, action: onConfirm) {
                    Text("Continue \(message)")
                }
            }
    }
    private func onConfirm() {
        _Haptics.play(.light)
        action()
    }
}
