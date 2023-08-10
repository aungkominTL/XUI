//
//  File.swift
//  
//
//  Created by Aung Ko Min on 3/7/23.
//

import SwiftUI

public enum XAccentColor {
    
    static let key = "com.jonahaung.XAccentColor"
    
    static var current: Color {
        get {
            guard let accentColor = UserDefaults.standard.string(forKey: Self.key), !accentColor.isEmpty else {
                return .accentColor
            }
            return Color(hex: accentColor)
        }
        set {
            UserDefaults.standard.setValue(newValue.toHex(), forKey: Self.key)
        }
    }
    
    public static func reset() {
        UserDefaults.standard.set(nil, forKey: Self.key)
    }
    
    public struct _Picker: View {
        @AppStorage(XAccentColor.key) private var value: String = ""
        public init() {}
        
        public var body: some View {
            ColorPicker(selection: .init(get: {
                XAccentColor.current
            }, set: { new in
                value = new.toHex().str
            }), supportsOpacity: false) {
                Text("Tint Color")
            }
        }
    }
    
    struct Modifier: ViewModifier {
        @AppStorage(XAccentColor.key) private var value: String = XAccentColor.current.toHex().str
        func body(content: Content) -> some View {
            content
                .tint(Color(hex: value))
        }
    }
    
}
extension View {
    func xAccentColor() -> some View {
        ModifiedContent(content: self, modifier: XAccentColor.Modifier())
    }
}
