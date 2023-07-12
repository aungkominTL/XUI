//
//  File.swift
//  
//
//  Created by Aung Ko Min on 4/7/23.
//


import Foundation
import SwiftUI

public struct PagerView<Content: View>: View {
    
    let pageCount: Int
    @State var ignore: Bool = false
    @Binding var currentIndex: Int {
        didSet {
            if (!ignore) {
                currentFloatIndex = CGFloat(currentIndex)
            }
        }
    }
    
    @State var currentFloatIndex: CGFloat = 0 {
        didSet {
            ignore = true
            currentIndex = min(max(Int(currentFloatIndex.rounded()), 0), self.pageCount - 1)
            ignore = false
        }
    }
    @ViewBuilder private var content: () -> Content

    @GestureState private var offsetX: CGFloat = 0

    public init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                self.content()
                    .frame(width: geometry.size.width)
            }
            .offset(x: -CGFloat(self.currentFloatIndex) * geometry.size.width)
            .offset(x: self.offsetX)
            .animation(.linear, value: offsetX)
            .highPriorityGesture(
                DragGesture().updating($offsetX) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded{ value in
                    let offset = value.translation.width / geometry.size.width
                    let offsetPredicted = value.predictedEndTranslation.width / geometry.size.width
                    let newIndex = CGFloat(self.currentFloatIndex) - offset
                    
                    if (offsetPredicted < -0.5 && offset > -0.5) {
                        currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() + 1), 0), self.pageCount - 1))
                    } else if (offsetPredicted > 0.5 && offset < 0.5) {
                        currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() - 1), 0), self.pageCount - 1))
                    } else {
                        currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded()), 0), self.pageCount - 1))
                    }
                }
            )
            .animation(.easeInOut, value: currentFloatIndex)
        }
        .onChange(of: currentIndex) { value in
            currentFloatIndex = CGFloat(value)
        }
    }
}
