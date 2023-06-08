//
//  XPicker.swift
//  Device Monitor
//
//  Created by Aung Ko Min on 21/9/22.
//

import SwiftUI
import XUI
@available(iOS 16.0, *)
public protocol _PickableItem {
    var title: String { get }
}
@available(iOS 16.0, *)
extension _PickableItem {
    var isEmpty: Bool { title.isWhitespace }
}
@available(iOS 16.0, *)
extension String: _PickableItem {
    public var title: String {
        self
    }
}
@available(iOS 16.0, *)
public struct _NavPickerBar<Item: _PickableItem>: View {
    private let title: String
    private let items: [Item]
    private var selection: Binding<Item>

    public init(_ _title: String = "", _ _items: [Item], _ _selection: Binding<Item>) {
        title = _title
        items = _items
        selection = _selection
    }

    public var body: some View {
        HStack {
            Text(.init(title))
            Spacer()
            Text(selection.wrappedValue.title)
                .foregroundColor(.accentColor)
        }
        .padding(.trailing)
        .overlay {
            NavigationLink {
                XPickerView(title: title, items: items, pickedItem: selection)
            } label: {
                Color.clear
            }
            .buttonStyle(.plain)
        }
    }
}
@available(iOS 16.0, *)
private struct XPickerView<Item: _PickableItem>: View {
    let title: String
    let items: [Item]
    @Binding var pickedItem: Item
    @State private var searchText = ""

    private var currentItems: [Item] {
        searchText.isEmpty ? items : items.filter{ $0.title.lowercased().contains(searchText.lowercased())}
    }
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollViewReader { scrollView in
            List {
                Section {
                    ForEach(currentItems, id: \.title) { item in
                        if !item.isEmpty {
                            AsyncButton(actionOptions: [.disableButton]) {
                                update(item)
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if item.title == pickedItem.title {
                                        Image(systemName: "circle.fill")
                                            .imageScale(.small)
                                    }
                                }
                            } onFinish: {
                                if !pickedItem.title.isWhitespace {
                                    dismiss()
                                }
                            }
                            .id(item.title)
                        }
                    }
                } footer: {
                    Text("total \(items.count) items")
                }
            }
            ._onAppear(after: 0.5) {
                scrollToSelectedItem(scrollView)
            }
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(trailing: trailingItem)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search \(title)")
        }
    }

    private var trailingItem: some View {
        Button("Clear") {
            clearItem()
            dismiss()
        }
        .disabled(pickedItem.title.isWhitespace)
    }

    private func scrollToSelectedItem(_ scrollView: ScrollViewProxy) {
        if !pickedItem.isEmpty {
            withAnimation {
                scrollView.scrollTo(pickedItem.title, anchor: .center)
            }
        }
    }
    private func clearItem() {
        let empty = items.filter { $0.title.isWhitespace }.first
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
        dismiss()
    }
}
