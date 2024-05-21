//
//  File.swift
//  
//
//  Created by Aung Ko Min on 10/6/23.
//

import Foundation

// Array
public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

public extension Array {

    mutating func shuffle() {
        if count == 0 {
            return
        }
        
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if j != i {
                self.swapAt(i, j)
            }
        }
    }
    
    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        
        return list
    }
    func random() -> Element? {
        return (count > 0) ? self.shuffled()[0] : nil
    }
    func random(_ count: Int = 1) -> [Element] {
        let result = shuffled()
        
        return (count > result.count) ? result : Array(result[0..<count])
    }
    
    func removeDuplicates(by predicate: (Element, Element) -> Bool) -> Self {
        var result = [Element]()
        for value in self where result.filter({ predicate($0, value) }).isEmpty {
            result.append(value)
        }
        return result
    }
    func removeDuplicates(by keyPath: KeyPath<Element, String>) -> Self {
        removeDuplicates(by: { $0[keyPath: keyPath] == $1[keyPath: keyPath] })
    }
    func removeDuplicates() -> Self where Element: Equatable {
        removeDuplicates(by: ==)
    }
}

public extension Array {
    func groupByKey<Key: Hashable>(keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }
}
