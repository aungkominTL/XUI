//
//  TextIconRow.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 28/7/23.
//

import SwiftUI
import SFSafeSymbols

public struct ListRowLabel: View {
    
    private let alignment: HorizontalAlignment
    private let icon: SFSymbol?
    private let text: String
    
    public init(alignment: HorizontalAlignment = .listRowSeparatorLeading, _ icon: SFSymbol?, _ text: String) {
        self.alignment = alignment
        self.icon = icon
        self.text = text
    }
    
    @ViewBuilder
    public var body: some View {
        HStack(spacing: 0) {
            switch alignment {
            case .center:
                Color.clear
                if let icon {
                    SystemImage(icon)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                        .imageScale(.large)
                        .padding(.trailing)
                }
                Text(.init(text))
                    .fixedSize()
                Color.clear
            case .leading:
                if let icon {
                    SystemImage(icon)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                        .imageScale(.large)
                        .padding(.trailing)
                }
                Text(.init(text))
                    .fixedSize()
                Color.clear
            case .trailing:
                Color.clear
                if let icon {
                    SystemImage(icon)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                        .imageScale(.large)
                        .padding(.trailing)
                }
                Text(.init(text))
                    .fixedSize()
            default:
                if let icon {
                    SystemImage(icon)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                        .imageScale(.large)
                        .padding(.trailing)
                }
                Text(.init(text))
            }
        }
    }
}
