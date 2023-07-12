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
                .frame(height: 36)
            content
                .foregroundColor(.white)
        }
        ._flexible(.horizontal)
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
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary, lineWidth: 1)
                .frame(height: 36)
            content
        }
        ._flexible(.horizontal)
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
    let lineWIdth: CGFloat
    let background: Color
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: lineWIdth)
                .background(background)
            content
        }
    }
}

public extension View {
    func _borderStyle(_ color: Color = .secondary, _ lineWIdth: CGFloat = 1, background: Color = .clear) -> some View {
        ModifiedContent(content: self, modifier: BorderStyle(color: color, lineWIdth: lineWIdth, background: background))
    }
}
