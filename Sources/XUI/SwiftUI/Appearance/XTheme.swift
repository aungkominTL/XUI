//
//  File.swift
//  
//
//  Created by Aung Ko Min on 3/7/23.
//

import SwiftUI

private struct XThemeStyleModifier: ViewModifier {
    
    @AppStorage(XAccentColor.key) private var accentColor: String = XAccentColor.current.toHex().str
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @AppStorage(XColorScheme.key) private var style: XColorScheme = .current
    
    func body(content: Content) -> some View {
        content
            .xListStyle()
            .xFontDesign()
            .accentColor(Color(hex: accentColor) ?? nil)
            .colorScheme(style.colorScheme ?? colorScheme)
    }
}

public extension View {
    func xThemeStyle() -> some View {
        ModifiedContent(content: self, modifier: XThemeStyleModifier())
    }
}

