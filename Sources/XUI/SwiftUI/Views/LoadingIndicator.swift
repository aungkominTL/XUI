//
//  LoadingIndicator.swift
//  BmCamera
//
//  Created by Aung Ko Min on 28/3/21.
//

import SwiftUI


public struct LoadingIndicator: View {
    public init() {}
    public var body: some View {
        ProgressView()
            .tint(Color.secondary)
    }
}

private struct LoadingViewModifier: ViewModifier {
    
    let isLoading: Bool
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                LoadingIndicator()
            }
            content
                .allowsHitTesting(!isLoading)
                
        }
        .equatable(by: isLoading)
    }
}

public extension View {
    func showLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
