/**
*  SwiftUIFlow
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct WrappedHStack<Content>: View
where Content : View
{
    public var body: WrappedStack<Content>
}

public extension WrappedHStack {
    init(alignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.body = WrappedStack(.horizontal,
                         alignment: Alignment(horizontal: .leading, vertical: alignment),
                         spacing: spacing,
                         content: content)
    }
    init(alignment: VerticalAlignment = .center,
         horizontalSpacing: CGFloat? = nil,
         verticalSpacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.body = WrappedStack(.horizontal,
                         alignment: Alignment(horizontal: .leading, vertical: alignment),
                         horizontalSpacing: horizontalSpacing,
                         verticalSpacing: verticalSpacing,
                         content: content)
    }
}
