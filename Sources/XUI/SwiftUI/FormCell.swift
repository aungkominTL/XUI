//
//  FormCell.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
@available(iOS 16.0, *)

public struct FormCell<Left: View, Right: View>: View {
    
    @ViewBuilder var left: () -> Left
    @ViewBuilder var right: () -> Right

    init(left: @escaping () -> View, right: @escaping () -> View) {
        self.left = left
        self.right = right
    }
    public var body: some View {
        HStack {
            left()
                .foregroundStyle(.secondary)
            Spacer()
            right()
        }
    }
}
