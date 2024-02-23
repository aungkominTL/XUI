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
    
    public var design: Font.Design? {
        switch self {
        case .default:
            return nil
        case .Serif:
            return .serif
        case .Rounded:
            return .rounded
        case .Monospace:
            return .monospaced
        }
    }
    
    public static var current: Self {
        get {
            let string = UserDefaults.standard.string(forKey: self.key).str
            return .init(rawValue: string) ?? .default
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: self.key)
        }
    }
    public static func reset() {
        current = .default
    }
    public struct _Picker: View {
        @AppStorage(XFontDesign.key) private var design: XFontDesign = .default
        public init() {}
        public var body: some View {
            if #available(iOS 16.1, *) {
                Picker("Font Design", selection: $design) {
                    ForEach(XFontDesign.allCases) {
                        Text($0.rawValue)
                            .fontDesign($0.design)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            } else {
                EmptyView()
            }
        }
    }
    
    struct Modifier: ViewModifier {
        @AppStorage(XFontDesign.key) private var value: XFontDesign = .default
        func body(content: Content) -> some View {
            if #available(iOS 16.1, *) {
                content.fontDesign(value.design)
            } else {
                content
            }
        }
    }
}
extension View {
    func xFontDesign() -> some View {
        ModifiedContent(content: self, modifier: XFontDesign.Modifier())
    }
}
