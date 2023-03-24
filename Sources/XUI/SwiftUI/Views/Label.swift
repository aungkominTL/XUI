//
//  _Label.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct _Label<Left, Right>: View where Left: View, Right: View {

    private let spacing: CGFloat
    private var left: () -> Left
    private var right: () -> Right

    public init(spacing: CGFloat = 5, @ViewBuilder left: @escaping () -> Left, @ViewBuilder right: @escaping () -> Right) {
        self.spacing = spacing
        self.left = left
        self.right = right
    }
    public init(spacing: CGFloat = 5, iconName: String, text: String) {
        self.spacing = spacing
        self.left = {
            Image(systemName: iconName) as! Left
        }
        self.right = {
            Text(text) as! Right
        }
    }
    public var body: some View {
        HStack(spacing: spacing) {
            left()
                .imageScale(.small)
            right()
        }
    }
}
