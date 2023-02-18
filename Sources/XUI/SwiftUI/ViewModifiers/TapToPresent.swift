//
//  FullScreenPresenting.swift
//  MyBike
//
//  Created by Aung Ko Min on 29/11/21.
//

import SwiftUI

@available(iOS 16.0, *)
private struct PresentSheetModifier<Destination: View>: ViewModifier {

    @ViewBuilder var destination: (() -> Destination)
    @State private var isShown = false
    @Environment(\.colorScheme) private var colorScheme
    
    public func body(content: Content) -> some View {
        Button {
            isShown = true
        } label: {
            content
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isShown) {
            destination()
                .colorScheme(colorScheme)
                .accentColor(.accentColor)
        }
    }
}
@available(iOS 16.0, *)
private struct PresentFullScreenModifier<Destination: View>: ViewModifier {

    @ViewBuilder var destination: (() -> Destination)
    @State private var isShown = false
    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> some View {
        Button {
            isShown = true
        } label: {
            content
        }
        .buttonStyle(.borderless)
        .fullScreenCover(isPresented: $isShown) {
            destination()
                .colorScheme(colorScheme)
                .accentColor(.accentColor)
        }
    }
}

@available(iOS 16.0, *)
public extension View {
    func _presentSheet<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        ModifiedContent(content: self, modifier: PresentSheetModifier(destination: content))
    }
    func _presentFullScreen<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        ModifiedContent(content: self, modifier: PresentFullScreenModifier(destination: content))
    }
}
