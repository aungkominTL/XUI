//
//  SplashReduct.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/4/23.
//

import SwiftUI
@available(iOS 16.0.0, *)
private struct SplashReductView: ViewModifier {
    private let timeout: TimeInterval
    @State private var isActive = true

    public init(timeout: TimeInterval) {
        self.timeout = timeout
    }

    public func body(content: Content) -> some View {
        content
            .redacted(reason: isActive ? .placeholder : [])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                    withAnimation {
                        self.isActive = false
                    }
                }
            }
            .onDisappear {
                isActive = true
            }
    }
}
@available(iOS 16.0.0, *)
public extension View {
    func _splashReduct(for timeout: TimeInterval = 0.5) -> some View {
        modifier(SplashReductView(timeout: timeout))
    }
}
