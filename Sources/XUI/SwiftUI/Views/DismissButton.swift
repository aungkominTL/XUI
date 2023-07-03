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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    public init(isProtected: Bool = false, title: String = "Done") {
        self.isProtected = isProtected
        self.title = title
    }
    
    public var body: some View {
        Group {
            if isProtected {
                Text(.init(title))
                    ._comfirmationDialouge(message: "Are you sure to close?") {
                        Button("Continue to close", role: .destructive) {
                            dismiss()
                        }
                    }
            } else {
                Button(.init(title), role: .cancel) {
                    dismiss()
                }
            }
        }
        ._hidable(!presentationMode.wrappedValue.isPresented)
    }
}
