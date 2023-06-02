//
//  XBadgedModifier.swift
//  Device Monitor
//
//  Created by Aung Ko Min on 23/9/22.
//

import SwiftUI
@available(iOS 16.0.0, *)

private struct XBadgedModifier: ViewModifier {
    let string: String
    func body(content: Content) -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            content
            Text(string)
                .font(.footnote)
                .italic()
                .foregroundStyle(.secondary)
        }
    }
}
@available(iOS 16.0, *)
public extension View {
    func _badged(_ string: String) -> some View {
        ModifiedContent(content: self, modifier: XBadgedModifier(string: string))
    }
}
