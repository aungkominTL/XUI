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
        onScroll: ScrollAction? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onScroll = onScroll ?? { _ in }
        self.content = content
    }

    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let onScroll: ScrollAction
    private let content: () -> Content

    public typealias ScrollAction = (_ offset: CGPoint) -> Void

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ScrollViewOffsetTracker {
                content()
            }
        }.withScrollOffsetTracking(action: onScroll)
    }
}

struct ScrollViewWithOffsetTracking_Previews: PreviewProvider {

    struct Preview: View {

        @State
        var scrollOffset: CGPoint = .zero

        var body: some View {
            NavigationView {
                #if os(macOS)
                Color.clear
                #endif
                ScrollViewWithOffsetTracker(onScroll: updateScrollOffset) {
                    LazyVStack {
                        ForEach(1...100, id: \.self) {
                            Divider()
                            Text("\($0)")
                        }
                    }
                }
                .navigationTitle("\(Int(scrollOffset.y))")
            }
        }

        func updateScrollOffset(_ offset: CGPoint) {
            self.scrollOffset = offset
        }
    }

    static var previews: some View {
        Preview()
    }
}
