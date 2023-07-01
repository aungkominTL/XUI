//
//  File.swift
//  
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI

public struct _Tag<Content>: View where Content: View {

    private let content: () -> Content
    private let fgcolor: Color
    private let bgcolor: Color

    public init(fgcolor: Color? = .init(uiColor: .systemBackground), bgcolor: Color? = .gray, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.fgcolor = fgcolor ?? .black
        self.bgcolor = bgcolor ?? .gray
    }

    public var body: some View {
        content()
            .foregroundColor(fgcolor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(bgcolor)
            .cornerRadius(8)
    }
}
