//
//  Hidable.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 19/5/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
private struct HidableModifier: ViewModifier {
    @Binding var isHidden: Bool
    public func body(content: Content) -> some View {
        if !isHidden {
            content
        }
    }
}
@available(iOS 16.0.0, *)
public extension View {
    func _hidable(_ isHidden: Bool) -> some View {
        modifier(HidableModifier(isHidden: .constant(isHidden)))
    }
}
