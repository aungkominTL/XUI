//
//  XPicker.swift
//  Device Monitor
//
//  Created by Aung Ko Min on 21/9/22.
//

import SwiftUI

public protocol _PickableItem {
    var title: String { get }
}

extension _PickableItem {
    var isEmpty: Bool { title.isWhitespace || title == "Any" }
}

extension String: _PickableItem {
    public var title: String {
        self
    }
}

public struct _NavPickerBar<Item: _PickableItem>: View {

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
        .overlay {
            NavigationLink {
                XPickerView(title: title, items: items, pickedItem: selection)
            } label: {
               EmptyView()
            }
            .buttonStyle(.plain)
        }
    }
}

private struct XPickerView<Item: _PickableItem>: View {

    let title: String
    let items: [Item]
    @Binding var pickedItem: Item
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private var currentItems: [Item] {
        searchText.isEmpty ? items : items.filter{ $0.title.lowercased().contains(searchText.lowercased())}
    }

    var body: some View {
        ScrollViewReader { scrollView in
            List {
                Section {
                    ForEach(currentItems, id: \.title) { item in
                        if !item.isEmpty {
                            HStack {
                                let isSelected = item.title == pickedItem.title
                                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isSelected ? .accentColor : Color(uiColor: .quaternaryLabel))
                                    .imageScale(.large)

                                AsyncButton(actionOptions: [.disableButton]) {
                                    update(item)
                                } label: {
                                    HStack {
                                        Text(item.title)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                } footer: {
                    Text("total \(items.count) items")
                }
            }
            ._onAppear(after: 0.5) {
                scrollToSelectedItem(scrollView)
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitle(title, displayMode: .large)
            .navigationBarItems(leading: leadingItem, trailing: trailingItem)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search \(title)")
        }
    }

    private var leadingItem: some View {
        Button("Close") {
            dismiss()
        }
    }

    private var trailingItem: some View {
        Button("Clear") {
            clearItem()
        }
        .disabled(pickedItem.isEmpty)
    }

    private func scrollToSelectedItem(_ scrollView: ScrollViewProxy) {
        if !pickedItem.isEmpty {
            withAnimation {
                scrollView.scrollTo(pickedItem.title, anchor: .center)
            }
        }
    }
    private func clearItem() {
        let empty = items.filter { $0.isEmpty }.first
        if let empty {
            pickedItem = empty
        }
    }

    @MainActor private func update(_ item: Item) {
        if pickedItem.title == item.title {
            clearItem()
            return
        }
        pickedItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            dismiss()
        }
    }
}
