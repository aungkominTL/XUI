//
//  Loadable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//


import SwiftUI

private struct LoadingViewModifier: ViewModifier {
    var isLoading: Bool
    func body(content: Content) -> some View {
        content
            .overlay {
                isLoading ? ProgressView() : nil
            }
    }
}

public extension View {
    func _lodable(_ isLoading: Bool) -> some View {
        ModifiedContent(content: self, modifier: LoadingViewModifier(isLoading: isLoading))
    }
}
