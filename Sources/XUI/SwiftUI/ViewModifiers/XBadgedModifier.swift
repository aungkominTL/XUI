//
//  XBadgedModifier.swift
//  Device Monitor
//
//  Created by Aung Ko Min on 23/9/22.
//

import SwiftUI
@available(iOS 16.0.0, *)
public struct XBadgedModifier: ViewModifier {
    let string: String
    public init(string: String) {
        self.string = string
    }
    public func body(content: Content) -> some View {
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
    func xBadged(_ string: String) -> some View {
        ModifiedContent(content: self, modifier: XBadgedModifier(string: string))
    }
}



