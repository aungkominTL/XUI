//
//  FormCell.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import SwiftUI
@available(iOS 16.0, *)
public struct FormCell<Left: View, Right: View>: View {

    @ViewBuilder public var left: () -> Left
    @ViewBuilder public var right: () -> Right

    public var body: some View {
        HStack {
            left()
                .foregroundStyle(.secondary)
            Spacer()
            right()
        }
    }
}
