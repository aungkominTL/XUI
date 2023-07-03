//
//  File.swift
//  
//
//  Created by Aung Ko Min on 3/7/23.
//

import SwiftUI

public enum XColorScheme: String, CaseIterable, Identifiable {
    
    case auto = "Auto"
    case light = "Light"
    case dark = "Dark"
    
    public var id: String { rawValue }
    static let key = "com.jonahaung.XColorScheme"
    
    
    static var current: XColorScheme {
        get {
            let string = UserDefaults.standard.string(forKey: self.key).str
            return .init(rawValue: string) ?? .auto
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: self.key)
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .auto:
            return nil
        }
    }
    
    public struct _Picker: View {
        @AppStorage(XColorScheme.key) private var style: XColorScheme = .current
        public init() {}
        public var body: some View {
            Picker("Color Scheme", selection: $style) {
                ForEach(XColorScheme.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }
    
    
    struct Modifier: ViewModifier {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        @AppStorage(XColorScheme.key) private var style: XColorScheme = .current
        
        func body(content: Content) -> some View {
            content
                .colorScheme(style.colorScheme ?? colorScheme)
        }
    }
    
    public static func reset() {
        current = .auto
    }
}
extension View {
    func xColorScheme() -> some View {
        ModifiedContent(content: self, modifier: XColorScheme.Modifier())
    }
}
