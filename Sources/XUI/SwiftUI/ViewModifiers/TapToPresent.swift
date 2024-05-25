//
//  FullScreenPresenting.swift
//  MyBike
//
//  Created by Aung Ko Min on 29/11/21.
//

import SwiftUI

private struct PresentSheetModifier<Destination: View>: ViewModifier {
    
    @ViewBuilder var destination: (() -> Destination)
    var onDismiss: (() -> Void)?
    @State private var isShown = false
    
    public func body(content: Content) -> some View {
        AsyncButton {
            isShown = true
        } label: {
            content
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isShown, onDismiss: onDismiss) {
            destination()
        }
    }
}

private struct PresentFullScreenModifier<Destination: View>: ViewModifier {
    @ViewBuilder var destination: (() -> Destination)
    var onDismiss: (() -> Void)?
    @State private var isShown = false

    public func body(content: Content) -> some View {
        AsyncButton {
            isShown = true
        } label: {
            content
        }
        .buttonStyle(.borderless)
        .fullScreenCover(isPresented: $isShown, onDismiss: onDismiss) {
            destination()
        }
    }
}

@available(iOS 16.0, *)
public extension View {
    func _presentSheet<Content: View>(@ViewBuilder content: @escaping () -> Content, onDismiss: (() -> Void)? = nil) -> some View {
        ModifiedContent(content: self, modifier: PresentSheetModifier(destination: content, onDismiss: onDismiss))
    }
    func _presentFullScreen<Content: View>(@ViewBuilder content: @escaping () -> Content, onDismiss: (() -> Void)? = nil) -> some View {
        ModifiedContent(content: self, modifier: PresentFullScreenModifier(destination: content, onDismiss: onDismiss))
    }
}
