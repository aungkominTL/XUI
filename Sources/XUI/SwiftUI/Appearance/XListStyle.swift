//
//  _ListStyle.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/6/23.
//

import SwiftUI

public enum XListStyle: String, CaseIterable, Identifiable {

    case insetGrouped = "Inset Group"
    case grouped = "Group"
    case plain = "Plain"
    case inset = "Inset"
    case sidebar = "Sidebar"

    public var id: String { rawValue }
    public static let key = "com.jonahaung.listStyle"
    public static var current: XListStyle {
        get {
            let string = UserDefaults.standard.string(forKey: self.key).str
            return .init(rawValue: string) ?? .insetGrouped
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: self.key)
        }
    }
}

private struct XListStyleModifier: ViewModifier {
    
    let value: XListStyle

    func body(content: Content) -> some View {
        switch value {
        case .insetGrouped:
            content.listStyle(.insetGrouped)
        case .grouped:
            content.listStyle(.grouped)
        case .plain:
            content.listStyle(.plain)
        case .inset:
            content.listStyle(.inset)
        case .sidebar:
            content.listStyle(.sidebar)
        }
    }
}

public extension View {
    func xListStyle(_ value: XListStyle) -> some View {
        ModifiedContent(content: self, modifier: XListStyleModifier(value: value))
    }
}

public struct XListStylePicker: View {
    @AppStorage(XListStyle.key) private var style: XListStyle = .current
    public init() {}
    
    public var body: some View {
        Picker("List Style", selection: $style) {
            ForEach(XListStyle.allCases) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
    }
}
