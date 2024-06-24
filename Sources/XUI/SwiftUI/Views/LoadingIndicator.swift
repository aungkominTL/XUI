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
        SystemImage(.arrowTriangle2CirclepathCircleFill, 34)
            .fontWeight(.light)
            .phaseAnimation([.rotate(.north), .rotate(.north_360)])
            .foregroundStyle(.tint)
    }
}
private struct LoadingViewModifier: ViewModifier {
    
    let isLoading: Bool
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                if isLoading {
                    LoadingIndicator()
                }
            }
    }
}
public extension View {
    func showLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
