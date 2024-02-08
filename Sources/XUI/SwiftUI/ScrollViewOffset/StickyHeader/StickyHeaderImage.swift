//
//  StickyHeaderImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import SwiftUI

public struct StickyHeaderImage: View {
    public init(_ image: Image) {
        self.image = image
    }
    private let image: Image
    public var body: some View {
        Color.clear.background(
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipped()
    }
}
