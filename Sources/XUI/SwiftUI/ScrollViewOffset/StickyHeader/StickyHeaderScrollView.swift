//
//  StickyHeaderScrollView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import SwiftUI

public struct StickyHeaderScrollView<Header: View, Content: View>: View {
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let header: () -> Header
    private let headerHeight: CGFloat
    private let headerMinHeight: CGFloat?
    private let onScroll: ScrollAction?
    private let content: () -> Content
    
    public typealias ScrollAction = (_ offset: CGPoint, _ headerVisibleRatio: CGFloat) -> Void
    @State private var navigationBarHeight: CGFloat = 0
    @State private var scrollOffset: CGPoint = .zero
    
    private var headerVisibleRatio: CGFloat { (headerHeight + scrollOffset.y) / headerHeight }
    
    public init(
        _ axes: Axis.Set = .vertical,
        @ViewBuilder header: @escaping () -> Header,
        headerHeight: CGFloat,
        headerMinHeight: CGFloat? = nil,
        showsIndicators: Bool = true,
        onScroll: ScrollAction? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.header = header
        self.headerHeight = headerHeight
        self.headerMinHeight = headerMinHeight
        self.onScroll = onScroll
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollViewWithOffsetTracker(onScroll: handleScrollOffset) {
                VStack(spacing: 0) {
                    StickyHeader(content: header)
                        .frame(height: headerHeight)
                    content()
                        .frame(maxHeight: .infinity)
                }
            }
            .background()
            .onAppear {
                DispatchQueue.main.async {
                    navigationBarHeight = proxy.safeAreaInsets.top
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

private extension StickyHeaderScrollView {
    var isStickyHeaderVisible: Bool {
        guard let headerMinHeight else { return headerVisibleRatio <= 0 }
        return scrollOffset.y < -headerMinHeight
    }
    
    func handleScrollOffset(_ offset: CGPoint) {
        self.scrollOffset = offset
        self.onScroll?(offset, headerVisibleRatio)
    }
}
