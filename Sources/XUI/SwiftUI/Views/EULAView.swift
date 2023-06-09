//
//  EULA.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI

public struct _EULAView: View {

    private var hasAgreedEULA: Binding<Bool>
    private let text: String

    @Environment(\.dismiss) private var dismiss

    public init(hasAgreedEULA: Binding<Bool>, text: String) {
        self.hasAgreedEULA = hasAgreedEULA
        self.text = text
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Text("End-User license agreement ('Agreement')")
                    .font(.headline)
                Text(.init(text))
                    .font(.footnote)
                    .textSelection(.enabled)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            Button {
                if hasAgreedEULA.wrappedValue {
                    dismiss()
                } else {
                    hasAgreedEULA.wrappedValue = true
                }
            } label: {
                Text(hasAgreedEULA.wrappedValue ? "Close" : "I agree and continue")
                    ._borderedProminentButtonStyle()
            }
            .padding(.horizontal)
        }
        .statusBarHidden(true)
    }
}
