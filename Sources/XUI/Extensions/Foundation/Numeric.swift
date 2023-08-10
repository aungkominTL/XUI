//
//  File.swift
//  
//
//  Created by Aung Ko Min on 10/6/23.
//

import Foundation

extension Int: Identifiable {
    public var id: Int { self }
}

public extension Int {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    var double: Double {
        Double(self)
    }
    var float: Float {
        Float(self)
    }
}

public extension CGFloat {
    var int: Int {
        Int(self)
    }
    var double: Double {
        Double(self)
    }
    var float: Float {
        Float(self)
    }
}

public extension Float {
    var int: Int {
        Int(self)
    }
    var double: Double {
        Double(self)
    }
    var cgFloat: CGFloat {
        CGFloat(self)
    }
}
