//
//  Loadable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/1/23.
//


import SwiftUI
@available(iOS 16.0.0, *)
public struct LoadingViewModifier: ViewModifier {
    public var isLoading: Bool
    public func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .overlay {
                isLoading ? ProgressView() : nil
            }
    }
}

@available(iOS 16.0, *)
public extension View {
    func loadable(_ isLoading: Bool) -> some View {
        ModifiedContent(content: self, modifier: LoadingViewModifier(isLoading: isLoading))
    }
}
