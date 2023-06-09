//
//  File.swift
//  
//
//  Created by Aung Ko Min on 18/5/23.
//

import SwiftUI

public typealias _AsyncAction = (@Sendable () async -> Void)

struct LoadMoreKey: EnvironmentKey {
    static let defaultValue: _AsyncAction? = nil
}

extension EnvironmentValues {
    var loadMore: _AsyncAction? {
        get { self[LoadMoreKey.self] }
        set { self[LoadMoreKey.self] = newValue }
    }
}

extension PaginatedScrollView {
    public func moreLoadable(action: @escaping _AsyncAction) -> some View {
        environment(\.loadMore, action)
    }
}

public struct PaginatedScrollView<Content: View>: View {
    enum LoadingState: Hashable {
        case ready, starting, ended
    }
    @ViewBuilder private let content: () -> Content
    private var canLoadMore: Binding<Bool>
    @Environment(\.loadMore) public var loadMoreAction: _AsyncAction?
    @State private var state = LoadingState.ended
    @Namespace private var scrollAreaID

    public init(canLoadMore: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.canLoadMore = canLoadMore
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 2) {
                content()
                VStack {
                    if state == .starting {
                        ProgressView()
                    }
                }
                .frame(height: 50)
                .if(canLoadMore.wrappedValue) { view in
                    view
                        .saveBounds(viewId: scrollAreaID)
                }
            }
            .padding(2)
            ._flexible(.all)
        }
        .retrieveBounds(viewId: scrollAreaID) {
            didUpdateVisibleRect($0)
        }
        .coordinateSpace(name: scrollAreaID)
    }

    private func didUpdateVisibleRect(_ value: CGRect?) {
        guard canLoadMore.wrappedValue else { return }
        guard let value, state == .ready else {
            if state == .ended {
                updateState(.ready)
            }
            return
        }
        let nearBottom = value.maxY - UIScreen.main.bounds.height < 0
        guard nearBottom else { return }
        Task {
            updateState(.starting)
            await loadMoreAction?()
            updateState(.ended)
        }
    }

    func updateState(_ newValue: LoadingState) {
        state = newValue
    }
}
