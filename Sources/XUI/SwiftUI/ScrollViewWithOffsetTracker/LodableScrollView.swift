//
//  SwiftUIView.swift
//
//
//  Created by Aung Ko Min on 3/6/24.
//

import SwiftUI

public struct LodableScrollView<Content: View, ScrollID: Hashable>: View {
    
    public typealias Action = @Sendable () async -> Void
    
    private let axis: Axis.Set
    private let showsIndicators: Bool
    private let namespace: String
    private let content: () -> Content
    private let onLoadMore: Action
    
    @Binding var scrollPositionID: (ScrollID)?
    @State private var scrollViewContentSize: CGSize?
    @State private var isLoadingMore = false
    @State private var isRefreshing = false
    @State private var offset = CGPoint.zero
    private let triggerPoint: CGFloat = 2
    @State private var debouncedTask: Task<Void, Never>?
    
    public init(
        _ axis: Axis.Set = .vertical,
        scrollPositionID: Binding<ScrollID?>,
        showsIndicators: Bool = false,
        namespace: String,
        @ViewBuilder content: @escaping () -> Content,
        onLoadMore: @escaping @Sendable () async -> Void
    ) {
        self.axis = axis
        self._scrollPositionID = scrollPositionID
        self.showsIndicators = showsIndicators
        self.namespace = namespace
        self.content = content
        self.onLoadMore = onLoadMore
    }
    
    public var body: some View {
        GeometryReader{ geo in
            let scrollViewHeight = geo.size.height
            ScrollViewReader { scroll in
                ScrollViewWithOffsetTracker(axis, showsIndicators: showsIndicators, namespace: namespace) {
                    content()
                        .frame(width: geo.size.width)
                        .background {
                            Color.clear
                                .saveSize(viewId: "\(namespace)+contentSize")
                                .hidden()
                        }
                        .scrollTargetLayout()
                }
                .frame(size: geo.size)
                .scrollIndicatorsFlash(trigger: scrollViewContentSize)
                .animation(.smooth, value: scrollViewContentSize)
                .scrollViewOffset(namespace: namespace) { offset in
                    let oldValue = self.offset
                    self.offset = offset
                    if axis == .vertical {
                        guard offset.y <= oldValue.y else {
                            isLoadingMore = false
                            debouncedTask?.cancel()
                            debouncedTask = nil
                            return
                        }
                        if let scrollViewContentSize, !isLoadingMore {
                            
                            guard scrollViewContentSize.height > scrollViewHeight else { return }
                            let offsetY = offset.y
                            let trigger = (offsetY + scrollViewContentSize.height) / scrollViewHeight
                            if trigger < triggerPoint {
                                let loadingTask = Task { @MainActor in
                                    isLoadingMore = true
                                }
                                if Task.isCancelled { return }
                                debouncedTask = Task(priority: .background) {
                                    if Task.isCancelled { return }
                                    await onLoadMore()
                                    loadingTask.cancel()
                                }
                            }
                        }
                    }
                }
                .retrieveSize(viewId: "\(namespace)+contentSize", $scrollViewContentSize)
                .onChange(of: scrollViewContentSize ?? .zero) { oldValue, newValue in
                    if newValue.height > oldValue.height {
                        isLoadingMore = false
                    }
                }
                .onChange(of: scrollPositionID) { oldValue, newValue in
                    if let newValue {
                        scroll.scrollTo(newValue, anchor: .top)
                        self.scrollPositionID = nil
                    }
                }
            }
        }
    }
}
