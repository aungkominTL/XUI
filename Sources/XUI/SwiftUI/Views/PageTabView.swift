//
//  PageTabView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/4/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct _PageTabView<Items, ID, Content>: View where Items: RandomAccessCollection, ID: Hashable, Content: View {

    let items: Array<Items.Element>
    let keyPath: KeyPath<Items.Element, ID>
    let content: (Items.Element) -> Content

    class ViewModel<Items: RandomAccessCollection>: ObservableObject {
        @Published var ranges: [Int]
        @Published var current: Int = 0
        init(items: Items) {
            ranges = Array(0..<items.count)
        }
    }

    public init(_ items: Items, id: KeyPath<Items.Element, ID>, @ViewBuilder content: @escaping (Items.Element) -> Content) {
        self.items = items.map { val in val }
        self.keyPath = id
        self.content = content
        _model = .init(wrappedValue: .init(items: items))
    }

    @StateObject var model: ViewModel<Items>

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
