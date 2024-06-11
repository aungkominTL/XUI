//
//  StretchyHeaderScrollView.swift
//
//
//  Created by Aung Ko Min on 31/5/24.
//

import SwiftUI

public struct StretchyHeaderScrollView<Content: View, Header: View>: View {
    
    public typealias Action = @Sendable () async -> Void
    
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let namespace: String
    private let headerHeight: CGFloat
    private let multipliter: CGFloat
    private let content: () -> Content
    private let header: () -> Header
    private let onLoadMore: Action?
    private let onRefresh: Action?
    
    @State private var scrollViewOffset: CGFloat = 0
    @State private var scrollViewContentSize: CGSize?
    @State private var isLoadingMore = false
    @State private var isRefreshing = false
    
    public init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        namespace: String,
        headerHeight: CGFloat,
        multipliter: CGFloat,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header,
        onLoadMore: Action? = nil,
        onRefresh: Action? = nil
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.namespace = namespace
        self.headerHeight = headerHeight
        self.multipliter = multipliter
        self.content = content
        self.header = header
        self.onLoadMore = onLoadMore
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        GeometryReader{ geo in
            ScrollViewWithOffsetTracker(axis, showsIndicators: showsIndicators, namespace: namespace) {
                if onLoadMore == nil {
                    content()
                } else {
                    content()
                        .saveSize(viewId: "\(namespace)+contentSize")
                        .overlay(alignment: .bottom) {
                            if isLoadingMore {
                                LoadingIndicator()
                            }
                        }
                }
            }
            .scrollViewOffset(namespace: namespace) { offset in
                if axis == .vertical {
                    let offsetY = -offset.y.rounded(.down)
                    if offsetY != scrollViewOffset {
                        scrollViewOffset = offsetY
                        if onLoadMore != nil, let scrollViewContentSize {
                            if !isLoadingMore {
                                let scrollViewHeight = geo.size.height
                                let maxOffset = scrollViewContentSize.height - scrollViewHeight
                                let trigger = maxOffset - offsetY
                                if trigger < 150 {
                                    isLoadingMore = true
                                    Task {
                                        await onLoadMore?()
                                    }
                                }
                            }
                        }
                        if onRefresh != nil {
                            if isRefreshing && offsetY == 0 {
                                isRefreshing = false
                                Task {
                                    await onRefresh?()
                                }
                            } else if !isRefreshing && offsetY == -180 {
                                isRefreshing = true
                            }
                        }
                    }
                }
            }
            .retrieveSize(viewId: "\(namespace)+contentSize", $scrollViewContentSize)
            .stretchyHeader($scrollViewOffset, height: headerHeight, multiplier: multipliter) {
                header()
                    .overlay(alignment: .top) {
                        if isRefreshing {
                            LoadingIndicator()
                        }
                    }
            }
            .onChange(of: scrollViewContentSize ?? .zero) { oldValue, newValue in
                if oldValue.height < newValue.height && isLoadingMore {
                    isLoadingMore = false
                }
            }
        }
    }
}
