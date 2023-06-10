//
//  File.swift
//  
//
//  Created by Aung Ko Min on 10/6/23.
//

import Foundation

// Optional
public extension Optional {
    var forceUnwrapped: Wrapped! {
        if let value = self {
            return value
        }
        fatalError()
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
public extension Optional where Wrapped == String {
    var str: String {
        return self ?? ""
    }
}
