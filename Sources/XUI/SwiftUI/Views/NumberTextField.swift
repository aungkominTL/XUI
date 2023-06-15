//
//  IntTextField.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 30/1/23.
//

import SwiftUI

public struct _NumberTextField: View {

    private var value: Binding<Int>
    private let title: String
    private let delima: String?

    public init(value: Binding<Int>, title: String, delima: String? = nil) {
        self.value = value
        self.title = title
        self.delima = delima
    }

    public var body: some View {
        HStack {
            Text(.init(title))
                .foregroundStyle(value.wrappedValue > 0 ? .tertiary : .primary)

            HStack(spacing: 0) {
                if let delima {
                    Text(delima)
                        .foregroundStyle(value.wrappedValue > 0 ? .primary : .tertiary)
                }
                TextField("\(delima.str)0", text: .init(get: getValue, set: setValue(_:)), prompt: Text("0"))
                    .keyboardType(.numberPad)
            }
        }
    }

    private func getValue() -> String {
        if value.wrappedValue == 0 { return String() }
        return "\(value.wrappedValue)"
    }

    private func setValue(_ newValue: String) {
        value.wrappedValue = Int(newValue) ?? 0
    }
}
