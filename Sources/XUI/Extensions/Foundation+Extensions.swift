//
//  Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import Foundation

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
}
