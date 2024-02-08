//
//  StickyHeaderGradient.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import SwiftUI

/**
 This view can be used as a scroll view header overlay, when
 the background may cause the content to be hard to overview.

 This is basically just a convenience to avoid having to use
 a `LinearGradient` and define its colors, anchor points etc.
 */
public struct StickyHeaderGradient: View {

    /**
     Create a scroll view header gradient.

     - Parameters:
       - startColor: The top start color, by default `.clear`.
       - endColor: The bottom end color, by default `.black` with `0.3` opacity.
     */
    public init(
        _ startColor: Color = .clear,
        _ endColor: Color = .black.opacity(0.4)
    ) {
        self.init(startColor, .top, endColor, .bottom)
    }

    /**
     Create a scroll view header gradient.

     - Parameters:
       - startColor: The top start color, by default `.clear`.
       - startPoint: The top start point.
       - endColor: The bottom end color, by default `.black` with `0.3` opacity.
       - endPoint: The top start point.
     */
    public init(
        _ startColor: Color = .clear,
        _ startPoint: UnitPoint,
        _ endColor: Color = .black.opacity(0.3),
        _ endPoint: UnitPoint
    ) {
        self.startColor = startColor
        self.startPoint = startPoint
        self.endColor = endColor
        self.endPoint = endPoint
    }

    private let startColor: Color
    private let startPoint: UnitPoint
    private let endColor: Color
    private let endPoint: UnitPoint

    public var body: some View {
        LinearGradient(
            colors: [startColor, endColor],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

#Preview {

    VStack {
        StickyHeaderGradient()
        StickyHeaderGradient(.blue, .topLeading, .yellow, .bottom)
    }
}

