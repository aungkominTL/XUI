//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI

public struct _Tag<Content>: View where Content: View {
    
    private let content: () -> Content
    private let color: Color
    
    public init(color: Color = .secondary, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.color = color
    }
    
    public var body: some View {
        content()
            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium, design: .serif))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            ._borderStyle(color)
        
    }
}
