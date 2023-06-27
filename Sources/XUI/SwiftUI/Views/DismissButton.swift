//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI

public struct _DismissButton: View {

    private let isProtected: Bool
    private let title: String
    @Environment(\.presentationMode) private var presentationMode

    public init(isProtected: Bool = false, title: String = "Close") {
        self.isProtected = isProtected
        self.title = title
    }

    public var body: some View {
        if isProtected {
            Text(.init(title))
                ._comfirmationDialouge(message: "Are you sure to close?") {
                    Button("Continue to close", role: .destructive) {
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
