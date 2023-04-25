//
//  OnAppearAfter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/4/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
private struct OnAppearAfterModifier: ViewModifier {

    private let timeout: TimeInterval
    private let perform: () -> Void

    public init(timeout: TimeInterval, perform: @escaping () -> Void) {
        self.timeout = timeout
        self.perform = perform
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                    perform()
                }
            }
    }
}

@available(iOS 16.0.0, *)
public extension View {
    func _onAppear(after timeout: TimeInterval, _ perform: @escaping () -> Void) -> some View {
        modifier(OnAppearAfterModifier(timeout: timeout, perform: perform))
    }
}
