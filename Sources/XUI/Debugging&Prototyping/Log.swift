//
//  Log.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 19/1/23.
//

import Foundation

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
#if DEBUG
    guard let object = object else { return }
    print("> \(funcname),  \(filename.components(separatedBy: "/").last ?? ""),  Line: \(line),  Object: \(object)")
#endif
}
