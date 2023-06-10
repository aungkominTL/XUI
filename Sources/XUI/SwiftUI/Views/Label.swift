//
//  _Label.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/23.
//

import SwiftUI

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

public struct _IconLabel: View {

    private let spacing: CGFloat
    private var icon: String
    private var title: String

    public init(icon: String, _ title: String, spacing: CGFloat = 0) {
        self.spacing = spacing
        self.icon = icon
        self.title = title
    }
    public init(_ systemImageName: SystemImageName, _ title: String, spacing: CGFloat = 2) {
        self.init(icon: systemImageName.rawValue, title, spacing: spacing)
    }
    public var body: some View {
        _Label(spacing: spacing) {
            Image(systemName: icon)
        } right: {
            Text(.init(title))
        }
    }
}
