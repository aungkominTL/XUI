//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI
@available(iOS 16.0.0, *)
private struct BorderedProminentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.accentColor)
            content
                .foregroundColor(Color(uiColor: .systemBackground))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
    }
}
@available(iOS 16.0.0, *)`
public extension View {
    func _borderedProminentButtonStyle() -> some View {
        ModifiedContent(content: self, modifier: BorderedProminentButtonStyle())
    }
}
