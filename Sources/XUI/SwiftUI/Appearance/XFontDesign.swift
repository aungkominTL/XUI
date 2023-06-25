//
//  File.swift
//  
//
//  Created by Aung Ko Min on 26/6/23.
//

import SwiftUI

public enum XFontDesign: String, Identifiable, CaseIterable {
    
    case `default`, Serif, Rounded, Monospace

    public var id: String { rawValue }
    public static let key = "com.jonahaung.fontDesign"

    public var design: Font.Design {
        switch self {
        case .default:
            return .default
        case .Serif:
            return .serif
        case .Rounded:
            return .rounded
        case .Monospace:
            return .monospaced
        }
    }
}

public struct XFontDesignPicker: View {

    @AppStorage(XFontDesign.key) private var design: XFontDesign = .default

    public init() {}

    public var body: some View {
        Picker("Font Design", selection: $design) {
            ForEach(XFontDesign.allCases) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
    }
}
