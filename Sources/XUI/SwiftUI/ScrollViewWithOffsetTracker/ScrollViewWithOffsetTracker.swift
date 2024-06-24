//
//  ScrollViewWithOffsetTracker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import SwiftUI

public struct ScrollViewWithOffsetTracker<Content: View>: View {
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        namespace: String,
        onScroll: ScrollAction? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.namespace = namespace
        self.onScroll = onScroll ?? { _ in }
        self.content = content
    }

    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let namespace: String
    private let onScroll: ScrollAction
    private let content: () -> Content

    public typealias ScrollAction = @Sendable (CGPoint) -> Void

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ScrollViewOffsetTracker(namespace: namespace) {
                content()
            }
        }
        .scrollViewOffset(namespace: namespace, action: onScroll)
    }
}

struct ScrollViewOffsetTracker<Content: View>: View {

    private let namespace: String
    init(
        namespace: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.namespace = namespace
        self.content = content
    }

    private var content: () -> Content

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geo.frame(in: .named(namespace)).origin
                    )
            }
            .frame(height: 0)
            content()
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
