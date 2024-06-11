//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 17/7/23.
//

import SwiftUI

public struct EqualableView<Content: View, Value: Equatable>: Equatable, View {
    
    public let content: Content
    public let value: Value
    
    public var body: some View {
        content
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

public extension View {
    /// Prevents the view from updating its child view when its new given value is the same as its old given value.
    func equatable<Value: Equatable>(by value: Value) -> some View {
        EqualableView(content: self, value: value)
            .equatable()
    }
}
