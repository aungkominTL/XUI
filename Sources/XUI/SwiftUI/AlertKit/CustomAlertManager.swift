//
//  CustomAlertManager.swift
//  XUI
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI

public class CustomAlertManager: ObservableObject {
    @Published public var isPresented: Bool
    
    public init(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    public func show() {
        withAnimation {
            isPresented = true
        }
    }
    
    public func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}
