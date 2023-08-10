//
//  File.swift
//  
//
//  Created by Aung Ko Min on 19/7/23.
//

import Combine

public extension Publisher where Self.Failure == Never {
    func sink(receiveValue: @escaping ((Self.Output) async -> Void)) -> AnyCancellable {
        sink { value in
            Task {
                await receiveValue(value)
            }
        }
    }
}
