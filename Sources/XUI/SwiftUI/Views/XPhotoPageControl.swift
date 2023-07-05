//
//  XPhotoPageControl.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 4/7/23.
//

import SwiftUI

public struct XPhotoPageControl<Selected: Hashable, Item: Identifiable>: View where Item.ID == Selected {
    
    private var selected: Binding<Selected>
    private var items: [Item]
    
    public init(selected: Binding<Selected>, items: [Item]) {
        self.selected = selected
        self.items = items
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { (i, item) in
                let isSelected = selected.wrappedValue == item.id
                Circle().fill(.foreground)
                    .frame(square: isSelected ? 18 : 10)
                    .padding(.vertical, 5)
            }
        }
        .animation(.default, value: selected.wrappedValue)
        ._hidable(items.count <= 1)
    }
}
