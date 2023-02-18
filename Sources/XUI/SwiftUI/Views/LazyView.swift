//
//  LazyView.swift
//  Msgr
//
//  Created by Aung Ko Min on 12/10/22.
//
import SwiftUI

@available(iOS 13.0, *)
public struct _LazyView<Content: View>: View {

    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}
