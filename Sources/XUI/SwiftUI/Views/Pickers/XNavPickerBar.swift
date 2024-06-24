//
//  XPicker.swift
//  Device Monitor
//
//  Created by Aung Ko Min on 21/9/22.
//

import SwiftUI

public struct XNavPickerBar<Item: XPickable>: View {
    
    private let title: String
    private let items: [Item]
    private var selection: Binding<Item>
    
    public init(_ _title: String = "Picker", _ _items: [Item], _ _selection: Binding<Item>) {
        title = _title
        items = _items
        selection = _selection
    }
    
    public var body: some View {
        HStack {
            Text(.init(title))
                .foregroundStyle(selection.wrappedValue.isEmpty ? .primary : .secondary)
            Spacer()
            Text(selection.wrappedValue.title)
        }
        .padding(.trailing)
        ._tapToPush {
            XPickerView(title: title, items: items.filter{ $0.title != "Any" && $0.title != "" }, pickedItem: selection)
        }
        .buttonStyle(.plain)
    }
}

private struct XPickerView<Item: XPickable>: View {
    
    let title: String
    let items: [Item]
    @Binding var pickedItem: Item
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented = false
    private var currentItems: [Item] {
        searchText.isEmpty ? items : items.filter{ $0.title.lowercased().contains(searchText.lowercased())}
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            List {
                Section {
                    ForEach(currentItems) { item in
                        HStack {
                            let isSelected = item.title == pickedItem.title
                            SystemImage(isSelected ? .checkmark : .circle)
                                .symbolVariant(isSelected ? .circle.fill : .none)
                                .foregroundColor(isSelected ? .green : Color.quaternaryLabel)
                            AsyncButton(actionOptions: [.disableButton]) {
                                update(item)
                                try await Task.sleep(for: .seconds(0.15))
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            } onFinish: {
                                dismiss()
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    if currentItems.isEmpty {
                        ContentUnavailableView.search
                    }
                } footer: {
                    Text("total \(items.count) items")
                }
            }
            ._onAppear(after: 1) {
                scrollToSelectedItem(scrollView)
            }
        }
        .navigationBarTitle(title, displayMode: .large)
        .navigationBarItems(trailing: trailingItem)
        .searchable(text: $searchText, isPresented: $isPresented, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search \(title)")
    }
    
    private var trailingItem: some View {
        AsyncButton {
            isPresented = true
        } label: {
            SystemImage(.magnifyingglass)
        }
    }
    
    private func scrollToSelectedItem(_ scrollView: ScrollViewProxy) {
        if !pickedItem.isEmpty {
            withAnimation {
                scrollView.scrollTo(pickedItem.title, anchor: .center)
            }
        }
    }
    
    @MainActor private func update(_ item: Item) {
        if pickedItem.title == item.title {
            pickedItem = Item.empty
            return
        }
        pickedItem = item
    }
}
