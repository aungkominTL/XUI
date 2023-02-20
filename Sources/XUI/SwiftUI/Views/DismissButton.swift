//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI
@available(iOS 16.0, *)
public struct _DismissButton: View {

    private let isProtected: Bool
    private let title: String

    public init(isProtected: Bool = false, title: String = "Cancel") {
        self.isProtected = isProtected
        self.title = title
    }
    @Environment(\.presentationMode) private var presentationMode

    public var body: some View {
        if isProtected {
            Text(.init(title))
                ._comfirmationDialouge(message: "You have unsaved changes. Are you sure you want to quit?") {
                    Button("Discard & Quit", role: .destructive) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        } else {
            Button(.init(title), role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
