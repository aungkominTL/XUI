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
    private let padding: CGFloat
    
    public init(_ padding: CGFloat = 0, content: @escaping () -> Content, @ViewBuilder header: @escaping (() -> Header) = { Group {} }, @ViewBuilder footer: @escaping (() -> Footer) = { Group {} }) {
        self.content = content
        self.header = header
        self.footer = footer
        self.padding = padding.scaled
    }
    
    public var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                header()
                    .font(.subheadline)
                content()
                footer()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(padding)
            ._flexible(.horizontal)
        }
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
