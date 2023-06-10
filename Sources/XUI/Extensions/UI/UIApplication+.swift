//
//  Extensions.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 27/1/23.
//

import UIKit

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
