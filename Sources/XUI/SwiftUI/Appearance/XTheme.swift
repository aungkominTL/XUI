//
//  File.swift
//  
//
//  Created by Aung Ko Min on 3/7/23.
//

import SwiftUI

private struct XThemeStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .xFontDesign()
            .xAccentColor()
            .xColorScheme()
    }
}

public extension View {
    func xThemeStyle() -> some View {
        ModifiedContent(content: self, modifier: XThemeStyleModifier())
    }
}
