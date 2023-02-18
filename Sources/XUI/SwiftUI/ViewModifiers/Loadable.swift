//
//  Loadable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//


import SwiftUI
@available(iOS 16.0.0, *)
private struct LoadingViewModifier: ViewModifier {
    var isLoading: Bool
    func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay {
                isLoading ? ProgressView() : nil
            }
    }
}

@available(iOS 16.0, *)
public extension View {
    func _lodable(_ isLoading: Bool) -> some View {
        ModifiedContent(content: self, modifier: LoadingViewModifier(isLoading: isLoading))
    }
}
