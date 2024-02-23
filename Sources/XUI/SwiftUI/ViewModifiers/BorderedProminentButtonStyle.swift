//
//  File.swift
//  
//
//  Created by Aung Ko Min on 20/2/23.
//

import SwiftUI

private struct BorderedProminentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
        }
        .foregroundStyle(Color.systemBackground)
        .frame(height: 38)
        ._flexible(.horizontal)
        .background(Color.accentColor.gradient, in: Capsule())
    }
}

public extension View {
    func _borderedProminentButtonStyle() -> some View {
        ModifiedContent(content: self, modifier: BorderedProminentButtonStyle())
    }
}

private struct BorderedProminentLightButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
        }
        .frame(height: 38)
        ._flexible(.horizontal)
        .background(Color(uiColor: .opaqueSeparator).gradient, in: Capsule())
    }
}

public extension View {
    func _borderedProminentLightButtonStyle() -> some View {
        ModifiedContent(content: self, modifier: BorderedProminentLightButtonStyle())
    }
}

private struct NavigationLinkStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            content
                .fixedSize()
            Color.clear
            SystemImage(.chevronRight)
                .imageScale(.small)
                .foregroundStyle(.tertiary)
        }
        .foregroundColor(.primary)
    }
}

public extension View {
    func _navigationLinkStyle() -> some View {
        ModifiedContent(content: self, modifier: NavigationLinkStyle())
    }
}

private struct BorderStyle: ViewModifier {
    
    let color: Color
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: lineWidth)
            content
        }
    }
}

public extension View {
    func _borderStyle(_ color: Color = .secondary, _ lineWidth: CGFloat = 1) -> some View {
        ModifiedContent(content: self, modifier: BorderStyle(color: color, lineWidth: lineWidth))
    }
}
