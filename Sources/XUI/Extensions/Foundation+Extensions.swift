//
//  Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI

// Strin
public extension String {
    
    func replace(_ target: String, with string: String) -> String {
        self.replacingOccurrences(of: target, with: string, options: NSString.CompareOptions.literal, range: nil)
    }
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var withoutSpacesAndNewLines: String {
        trimmed.replace(" ", with: "")
    }
    func toCurrencyFormat() -> String {
        if let intValue = Int(self){
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = .current
            numberFormatter.numberStyle = .currency
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
        }
        return ""
    }
    
    var isWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var notEmpty: Bool { !isWhitespace }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }
    
    var language: String { NSLinguisticTagger.dominantLanguage(for: self) ?? ""}
    
    var nonLineBreak: String {
        self.replacingOccurrences(of: " ", with: "\u{00a0}")
    }
    
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    func words() -> [String] {
        let comps = components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return comps.filter { !$0.isWhitespace }
    }
    
    func nsRange() -> NSRange {
        NSRange.init(self.startIndex..<self.endIndex, in: self)
    }

    var localizedKey: LocalizedStringKey {
        .init(self)
    }
    
    var stringsBesideColon: (String?, String) {
        let strings = split(separator: ":").map(String.init)
        if strings.count == 2, strings[0].notEmpty {
            return (strings[0], strings[1])
        }
        return (nil, self)
    }
    var firstLetterCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }

}

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


public extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}

public extension DispatchQueue {
    static func safeAsync(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
}

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


// MARK: Dictionary
public extension Dictionary {
    var tuples: [(Key, Value)] {
        map({ ($0.key, $0.value) })
    }
}

// MARK: TimeInterval
public extension TimeInterval {
    static let oneYear: Self = .init(60 * 60 * 24 * 365)
    static let oneWeek: Self = .init(60 * 60 * 24 * 7)
}

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
