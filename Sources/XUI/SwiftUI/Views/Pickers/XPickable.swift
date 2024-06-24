//
//  XPickable.swift
//
//
//  Created by Aung Ko Min on 12/8/23.
//

import Foundation

public protocol XPickable: Hashable, Identifiable, Sendable, EmptyRepresentable, CaseIterable {
    var title: String { get }
}

extension XPickable {
    var isEmpty: Bool { self == Self.empty }
}

public protocol EmptyRepresentable {
    static var empty: Self { get }
}

extension String: XPickable {
    public static var allCases: [String] {
        [""]
    }
    public static var empty: String {
        ""
    }
    public var title: String {
        self.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
