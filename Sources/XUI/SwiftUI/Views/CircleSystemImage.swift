//
//  CircleSystemImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import SwiftUI
import SFSafeSymbols

public struct CircleSystemImage<BG: View>: View {
    
    private let icon: SFSymbol
    private let background: BG
    private let scale: CGFloat
    
    public init(_ icon: SFSymbol, _ background: BG, _ scale: CGFloat = 1) {
        self.icon = icon
        self.background = background
        self.scale = scale
    }
    
    public var body: some View {
        SystemImage(icon, 18 * scale)
            .imageScale(.small)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(Color(uiColor: .systemBackground))
            .padding(6 * scale)
            .background {
                background
                    .opacity(0.8)
                    .clipShape(.containerRelative)
            }
            .background(.fill.tertiary)
            .containerShape(.circle)
            .compositingGroup()
            .symbolVariant(.fill)
    }
}
