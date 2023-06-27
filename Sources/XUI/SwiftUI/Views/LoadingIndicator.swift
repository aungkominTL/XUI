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

    init(size: CGFloat = UIFont.preferredFont(forTextStyle:  .title2).lineHeight) {
        self.size = size
    }
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.85)
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .round))
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear(duration: 0.75).repeatForever(autoreverses: false), value: isLoading)
            .frame(square: size)
            .task {
                self.isLoading = true
            }
    }
}
