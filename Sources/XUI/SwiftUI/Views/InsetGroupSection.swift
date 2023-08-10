//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 16/7/23.
//

import SwiftUI

public struct _InsetGroupSection<Content: View, Header: View, Footer: View>: View {
    
    @ViewBuilder private var content: () -> Content
    @ViewBuilder private var header: (() -> Header)
    @ViewBuilder private var footer: (() -> Footer)
    

    public init(content: @escaping () -> Content, @ViewBuilder header: @escaping (() -> Header) = { Group {} }, @ViewBuilder footer: @escaping (() -> Footer) = { Group {} }) {
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            header()
                .font(.subheadline.bold())
                .padding(.horizontal)
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            
                Group {
                    content()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 11))
            
            footer()
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct TableCellStyle: ViewModifier {
    let padding: EdgeInsets
    func body(content: Content) -> some View {
        content
            .padding(padding)
        Divider()
            .padding(.leading)
    }
}

public extension View {
    func tableCellStyle(_ padding: EdgeInsets = .init(top: UIFontMetrics.default.scaledValue(for: 8), leading: UIFontMetrics.default.scaledValue(for: 16), bottom: UIFontMetrics.default.scaledValue(for: 8), trailing: 0)) -> some View {
        self.modifier(TableCellStyle(padding: padding))
    }
}
