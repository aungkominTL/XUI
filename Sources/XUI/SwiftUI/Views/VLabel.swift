//
//  File.swift
//  
//
//  Created by Aung Ko Min on 23/4/23.
//

import SwiftUI

public struct _VLabel<Top, Bottom>: View where Top: View, Bottom: View {

    private let spacing: CGFloat
    private var top: () -> Top
    private var bottom: () -> Bottom

    public init(spacing: CGFloat = 5, @ViewBuilder top: @escaping () -> Top, @ViewBuilder bottom: @escaping () -> Bottom) {
        self.spacing = spacing
        self.top = top
        self.bottom = bottom
    }
    public init(spacing: CGFloat = 5, iconName: String, text: String) {
        self.spacing = spacing
        self.top = {
            Image(systemName: iconName) as! Top
        }
        self.bottom = {
            Text(text) as! Bottom
        }
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            top()
                .imageScale(.small)
            bottom()
        }
    }
}
