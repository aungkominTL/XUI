//
//  XPickable.swift
//  
//
//  Created by Aung Ko Min on 12/8/23.
//

import Foundation

public protocol XPickable: Identifiable, Equatable, Hashable {
    var title: String { get }
}

extension XPickable {
    var isEmpty: Bool { title.isWhitespace || title == "Any" }
}

extension String: XPickable {
    public var title: String {
        self
    }
}
