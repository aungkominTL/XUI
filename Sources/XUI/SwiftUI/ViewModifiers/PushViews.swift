//
//  NavigationLinkStyle.swift
//  MyBike
//
//  Created by Aung Ko Min on 28/11/21.
//

import SwiftUI

@available(iOS 13.0, *)
public struct PushViewModifier<Destination: View>: ViewModifier {
    
    @ViewBuilder public var destination: (() -> Destination)
    
    public func body(content: Content) -> some View {
        NavigationLink {
            destination()
        } label: {
            content
        }
        .buttonStyle(.borderless)
    }
}

@available(iOS 13.0, *)
public extension View {
    func tapToPush<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        ModifiedContent(content: self, modifier: PushViewModifier(destination: content))
    }
}
