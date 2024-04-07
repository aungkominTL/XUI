//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 16/7/23.
//

import SwiftUI

public struct InsetGroupSection<Content: View, Header: View, Footer: View>: View {
    
    @ViewBuilder private var content: () -> Content
    @ViewBuilder private var header: (() -> Header)
    @ViewBuilder private var footer: (() -> Footer)
    private let outerPadding: CGFloat
    private let innerPadding: CGFloat
    
    
    public init(outerPadding: CGFloat = 2, innerPadding: CGFloat = 2, content: @escaping () -> Content, @ViewBuilder header: @escaping (() -> Header) = { Group {} }, @ViewBuilder footer: @escaping (() -> Footer) = { Group {} }) {
        self.content = content
        self.header = header
        self.footer = footer
        self.outerPadding = UIFontMetrics.default.scaledValue(for: outerPadding)
        self.innerPadding = UIFontMetrics.default.scaledValue(for: innerPadding)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            header()
                .font(.callout)
                .padding(.horizontal, outerPadding + innerPadding)
            content()
                .padding(innerPadding)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .containerShape(RoundedRectangle(cornerRadius: min(12, innerPadding <= 4 ? 0 : innerPadding)))
                .compositingGroup()
            footer()
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, outerPadding + innerPadding)
        }
        .padding(outerPadding)
        ._flexible(.horizontal)
    }
}
struct TableCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .background(alignment: .bottom) {
                Divider().padding(.horizontal, 8)
            }
    }
}

public extension View {
    func tableCellStyle() -> some View {
        self.modifier(TableCellStyle())
    }
}
