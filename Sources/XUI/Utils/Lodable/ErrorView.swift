//
//  ErrorView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 23/3/23.
//

import SwiftUI

public struct ErrorView: View {
    
    public let error: Error
    public let retryAction: () -> Void
    
    public init(error: Error, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("An Error Occured")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
                .padding(.bottom)
            
            Button(action: retryAction, label: {
                Text("Retry")
            })
            Spacer()
        }
        .padding()
    }
}
