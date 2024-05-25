//
//  SystemImage.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/6/23.
//

import SwiftUI
import SFSafeSymbols

public struct SystemImage: View {
    
    private let systemName: String
    private let size: CGFloat?
    private var isRandomColor = false
    
    public init(systemName: String, _ _size: CGFloat? = nil) {
        self.systemName = systemName
        size = _size
    }
    
    public init(_ symbol: SFSafeSymbols.SFSymbol, _ size: CGFloat? = nil) {
        self.init(systemName: symbol.rawValue, size)
    }
    
    public var body: some View {
        Image(systemName: systemName)
            .if_let(size) { value, view in
                view
                    .resizable()
                    .scaledToFit()
                    .frame(square: value)
            }
            .scaledToFit()
    }
    
    public func relativeColor(_ value: Bool = true) -> Self {
        map{ $0.isRandomColor = value }
    }
}
