//
//  AlertItem.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI
@available(iOS 13.0, *)
public struct _Alert: Identifiable {

    public var id: String { title }
    private var title: String
    private var message: String?
    private var onCancel: (() -> Void)?

    public init(title: String, message: String? = nil, onCancel: ( () -> Void)? = nil) {
        self.title = title
        self.message = message
        self.onCancel = onCancel
    }

    public var view: Alert {
        Alert(title: Text(.init(title)), message: messageView, dismissButton: .cancel(Text("OK"), action: onCancel))
    }

    @ViewBuilder private var messageView: Text? {
        if let message {
            Text(.init(message))
        }
    }
}

@available(iOS 13.0, *)
public extension _Alert {
    init(error: Error) {
        self.init(title: "Error", message: error.localizedDescription)
    }
}


