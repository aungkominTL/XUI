//
//  ScrollViewOffsetTracker.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 11/12/23.
//

import SwiftUI

/**
 This view can be wrap any `ScrollView` or `List` content to
 get offset tracking working when the view is scrolled.

 To use this view, just add it to the `ScrollView` or `List`,
 add the content to it then apply `withScrollOffsetTracking`
 to the `ScrollView` or `List`:

 ```swift
 List {
     ScrollViewOffsetTracker {
         ForEach(0...100, id: \.self) {
             Text("\($0)")
                 .frame(width: 200, height: 200)
         }
     }
 }
 .withScrollOffsetTracking { offset in
    print(offset)
 }
 ```

 The offset tracking action will trigger whenever the scroll
 view scrolls, and provide you with the scroll offset.
 */
struct ScrollViewOffsetTracker<Content: View>: View {

    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    private var content: () -> Content

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geo.frame(in: .named(ScrollOffsetNamespace.namespace)).origin
                    )
            }
            .frame(height: 0)
            content()
        }
    }
}

enum ScrollOffsetNamespace {
    static let namespace = "scrollView"
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
