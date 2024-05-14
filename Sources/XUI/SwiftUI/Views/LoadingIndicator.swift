//
//  LoadingIndicator.swift
//  BmCamera
//
//  Created by Aung Ko Min on 28/3/21.
//

import SwiftUI

public struct LoadingIndicator: View {
    
    @State private var isLoading = false
    private let size: CGFloat
    
    public init(size: CGFloat = UIFont.preferredFont(forTextStyle:  .title2).lineHeight) {
        self.size = size
    }
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.85)
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .round))
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: isLoading)
            .frame(square: size)
            .fixedSize()
            .task {
                self.isLoading = true
            }
    }
}

private struct LoadingViewModifier: ViewModifier {
    var loading: Bool
    public func body(content: Content) -> some View {
        content
            .overlay {
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
