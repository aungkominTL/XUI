//
//  PageTabView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/4/23.
//

import SwiftUI

public struct _PageTabView<PageItems, ID, Content>: View where PageItems: RandomAccessCollection, ID: Hashable, Content: View {

    let items: Array<PageItems.Element>
    let keyPath: KeyPath<PageItems.Element, ID>
    let content: (PageItems.Element) -> Content

    class ViewModel<T: RandomAccessCollection>: ObservableObject {
        @Published var ranges: [Int]
        @Published var current: Int = 0
        init(items: T) {
            ranges = Array(0..<items.count)
        }
    }

    public init(_ items: PageItems, id: KeyPath<PageItems.Element, ID>, @ViewBuilder content: @escaping (PageItems.Element) -> Content) {
        self.items = items.map { val in val }
        self.keyPath = id
        self.content = content
        _model = .init(wrappedValue: .init(items: items))
    }

    @StateObject var model: ViewModel<PageItems>

    public var body: some View {
        TabView(selection: $model.current) {
            ForEach(model.ranges, id: \.self) { i in
                if let item = items[safe: i] {
                    content(item)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
