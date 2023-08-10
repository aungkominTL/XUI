//
//  SwiftUIView.swift
//  
//
//  Created by Aung Ko Min on 16/7/23.
//

import SwiftUI

public struct NotRequestedView: View {
    
    private let key: String
    private let message: String
    private let requestAction: () -> Void
    @State private var hasRequested: Bool
    
    public init(key: String, _ message: String, _ onRequest: @escaping () -> Void) {
        self.key = key
        self.message = message
        self.requestAction = onRequest
        hasRequested = UserDefaults.standard.bool(forKey: key)
    }
    
    public var body: some View {
        VStack {
            Spacer()
            if hasRequested {
                Color.clear
                    ._onAppear(after: 0.1, {
                        requestAction()
                    })
            } else {
                Text("We Need Your Permission")
                    .font(.headline)
                
                Text(message)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                Button {
                    UserDefaults.standard.set(true, forKey: key)
                    hasRequested = true
                } label: {
                    Text("OK")
                        .padding(.horizontal)
                }
            }
            Spacer()
        }
        .padding()
    }
}
