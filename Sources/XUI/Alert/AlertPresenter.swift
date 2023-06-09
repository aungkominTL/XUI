//
//  AlertPresenter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 8/2/23.
//

import SwiftUI
@available(iOS 13.0, *)
private struct AlertPresenter: ViewModifier {
    @Binding var item: _Alert?
    public func body(content: Content) -> some View {
        content
            .alert(item: $item) { $0.view }
    }
}

@available(iOS 13.0, *)
public extension View {
    func _alert(_ alertItem: Binding<_Alert?>) -> some View {
        ModifiedContent(content: self, modifier: AlertPresenter(item: alertItem))
    }
}

