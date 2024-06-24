/**
*  SwiftUIFlow
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct WrappedStack<Content>: View
where Content : View
{
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: alignment) {
                Color.clear
                    .hidden()
                
                WrappedStackLayout(alignment: alignment,
                           axis: axis,
                           content: content,
                           horizontalSpacing: horizontalSpacing ?? 3,
                           size: geometry.size,
                           verticalSpacing: verticalSpacing ?? 3)
                .transaction {
                    updateTransaction($0)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear { contentSize = geometry.size }
                            .onChange(of: geometry.size, initial: true) { (oldValue, newValue) in
                                DispatchQueue.main.async {
                                    withTransaction(transaction) {
                                        contentSize = newValue
                                    }
                                }
                            }
                    }
                    .hidden()
                )
            }
        }
        .frame(width: axis == .horizontal ? contentSize.width : nil,
               height: axis == .vertical ? contentSize.height : nil)
    }
    
    @State private var contentSize = CGSize.zero
    @State private var transaction = Transaction()
    
    private var alignment: Alignment
    private var axis: Axis
    private var content: () -> Content
    private var horizontalSpacing: CGFloat?
    private var verticalSpacing: CGFloat?
}


public extension WrappedStack {
    init(_ axis: Axis,
         alignment: Alignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
    }
    init(_ axis: Axis,
         alignment: Alignment = .center,
         horizontalSpacing: CGFloat? = nil,
         verticalSpacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.alignment = alignment
        self.axis = axis
        self.content = content
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
}

private extension WrappedStack {
    func updateTransaction(_ newValue: Transaction) {
        if transaction.animation != newValue.animation
            || transaction.disablesAnimations != newValue.disablesAnimations
            || transaction.isContinuous != newValue.isContinuous
        {
            DispatchQueue.main.async {
                transaction = newValue
            }
        }
    }
}
