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

    public var body: some View {
        HStack(spacing: spacing) {
            left()
            right()
        }
    }
}

@available(iOS 16.0, *)
public struct _IconLabel: View {

    private let spacing: CGFloat
    private var icon: String
    private var title: String

    public init(_ title: String, icon: String, spacing: CGFloat = 0) {
        self.spacing = spacing
        self.icon = icon
        self.title = title
    }
    public var body: some View {
        _Label(spacing: spacing) {
            Image(systemName: icon)
        } right: {
            Text(title)
        }
    }
}
