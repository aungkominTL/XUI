//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI

private struct BorderedProminentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.accentColor)
            content
                .foregroundColor(Color(uiColor: .tertiarySystemBackground))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}

public extension View {
    func _borderedProminentButtonStyle() -> some View {
        ModifiedContent(content: self, modifier: BorderedProminentButtonStyle())
    }
}

private struct BorderedProminentLightButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentColor, lineWidth: 1)
            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}

public extension View {
    func _borderedProminentLightButtonStyle() -> some View {
        ModifiedContent(content: self, modifier: BorderedProminentLightButtonStyle())
    }
}
