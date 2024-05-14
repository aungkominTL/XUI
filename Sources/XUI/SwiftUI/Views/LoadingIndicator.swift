//
//  LoadingIndicator.swift
//  BmCamera
//
//  Created by Aung Ko Min on 28/3/21.
//

import SwiftUI

public struct LoadingIndicator: View {
    private let size = UIFont.preferredFont(forTextStyle:  .title3).lineHeight
    public init() {}
    public var body: some View {
        SystemImage(.circle, size)
            .foregroundStyle(Color.link.gradient)
            .padding(4)
            .zIndex(5)
            .phaseAnimation([.scale(0.8), .scale(1.2)])
    }
}

private struct LoadingViewModifier: ViewModifier {
    var loading: Bool
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if loading {
                    LoadingIndicator()
                }
            }
    }
}

public extension View {
    func showLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(loading: isLoading))
    }
}
