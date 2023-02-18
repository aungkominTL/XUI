//
//  UI+Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/2/23.
//

import SwiftUI

@available(iOS 13.0, *)
public
extension View {
    @ViewBuilder func `if` <Content: View>(_ condition: Bool, _ transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
