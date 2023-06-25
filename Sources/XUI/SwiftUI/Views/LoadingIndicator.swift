//
//  LoadingIndicator.swift
//  BmCamera
//
//  Created by Aung Ko Min on 28/3/21.
//

import SwiftUI

public struct LoadingIndicator: View {

    @State private var isLoading = false

    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.85)
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .round))
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear(duration: 0.75).repeatForever(autoreverses: false), value: isLoading)
            .frame(width: 30, height: 30)
            .onAppear {
                self.isLoading = true
            }
    }
}
