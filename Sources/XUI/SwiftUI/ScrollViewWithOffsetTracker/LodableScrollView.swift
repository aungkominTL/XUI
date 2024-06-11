//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI

public struct LodableScrollView<Content: View>: View {
    
    public typealias Action = @Sendable () async -> Void
    
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let namespace: String
    private let content: () -> Content
    private let onLoadMore: Action?
    
    @State private var scrollViewContentSize: CGSize?
    @State private var isLoadingMore = false
    @State private var isRefreshing = false
    
    public init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        namespace: String,
        @ViewBuilder content: @escaping () -> Content,
        onLoadMore: Action? = nil
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.namespace = namespace
        self.content = content
        self.onLoadMore = onLoadMore
    }
    
    public var body: some View {
        GeometryReader{ geo in
            ScrollViewWithOffsetTracker(axis, showsIndicators: showsIndicators, namespace: namespace) {
                if onLoadMore == nil {
                    content()
                } else {
                    content()
                        .saveSize(viewId: "\(namespace)+contentSize")
                }
            }
            .scrollViewOffset(namespace: namespace) { offset in
                if axis == .vertical {
                    
                    if let onLoadMore, let scrollViewContentSize {
                        if !isLoadingMore {
                            let offsetY = -offset.y.rounded(.down)
                            
                            let scrollViewHeight = geo.size.height
                            let maxOffset = scrollViewContentSize.height - scrollViewHeight
                            guard maxOffset > scrollViewHeight else { return }
                            let trigger = maxOffset - offsetY
                            if trigger < scrollViewHeight {
                                isLoadingMore = true
                                Task {
                                    await onLoadMore()
                                }
                            }
                        }
                    }
                }
            }
            .retrieveSize(viewId: "\(namespace)+contentSize", $scrollViewContentSize)
            .onChange(of: scrollViewContentSize ?? .zero) { oldValue, newValue in
                if oldValue.height < newValue.height && isLoadingMore {
                    DispatchQueue.delay {
                        isLoadingMore = false
                    }
                }
            }
        }
    }
}
