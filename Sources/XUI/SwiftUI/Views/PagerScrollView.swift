//
//  PageTabView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/4/23.
//

import SwiftUI

@Observable
private class PagerScrollViewModel<T: RandomAccessCollection> {
    @ObservationIgnored var ranges: [Int]
    var current: Int = 0
    init(items: T) {
        ranges = Array(0..<items.count)
    }
}

public struct PagerScrollView<PageItems, ID, Content>: View where PageItems: RandomAccessCollection, ID: Hashable, Content: View {
    
    private let items: Array<PageItems.Element>
    private let keyPath: KeyPath<PageItems.Element, ID>
    private let content: (PageItems.Element) -> Content
    @Binding private var selection: Int
    @State private var model: PagerScrollViewModel<PageItems>
    
    public init(_ items: PageItems, id: KeyPath<PageItems.Element, ID>, selection: Binding<Int>, @ViewBuilder content: @escaping (PageItems.Element) -> Content) {
        self.items = items.map { val in val }
        self.keyPath = id
        self.content = content
        self._selection = selection
        _model = .init(wrappedValue: .init(items: items))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scroll in
                ScrollViewWithOffsetTracker(.horizontal, showsIndicators: false) { offset in
                    let count = model.ranges.count
                    let viewWidth = Int(geometry.size.width)
                    let totalWidth = viewWidth * count
                    let offsetX = Int(-offset.x) + (viewWidth/2)
                    let value = offsetX * count/totalWidth
                    if model.current != value {
                        model.current = value
                        selection = value
                    }
                } content: {
                    LazyHStack(spacing: 0) {
                        ForEach(model.ranges, id: \.self) { i in
                            if let item = items[safe: i] {
                                content(item)
                                    .containerRelativeFrame([.horizontal, .vertical])
                                    .clipped()
                                    .id(i)
                            }
                        }
                    }
                }
                .onChange(of: selection) { oldValue, newValue in
                    guard selection != model.current else {
                        return
                    }
                    scroll.scrollTo(newValue, anchor: .center)
                }
            }
            .scrollDisabled(model.ranges.count == 1)
            .scrollTargetBehavior(.paging)
            .overlay(alignment: .bottom) {
                if model.ranges.count > 1 {
                    XPhotoPageControl(selection: $model.current, length: model.ranges.count, size: 12)
                        .foregroundStyle(Color.white.gradient)
                        .padding(.bottom, 3)
                }
            }
        }
    }
}
