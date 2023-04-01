//
//  IntTextField.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 30/1/23.
//

import SwiftUI
@available(iOS 16.0, *)
public struct _NumberTextField: View {

    private var value: Binding<Int>
    private let title: String
    private let delima: String?

    public init(value: Binding<Int>, title: String, delima: String? = nil) {
        self.value = value
        self.title = title
        self.delima = delima
    }

    private func getValue() -> String {
        if value.wrappedValue == 0 { return String() }
        if let delima {
            return "\(delima)\(value)"
        }
        return "\(value)"
    }

    private func setValue(_ newValue: String) {
        if let delima {
            value.wrappedValue = Int(newValue.replace(delima, with: String())) ?? 0
        } else {
            value.wrappedValue = Int(newValue) ?? 0
        }
    }

    public var body: some View {
        TextField("Please input the \(title)", text: .init(get: getValue, set: setValue(_:)))
            .keyboardType(.numberPad)
    }
}
