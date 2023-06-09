//
//  Debouncer.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/5/23.
//

import SwiftUI
import Combine

public class Debouncer: ObservableObject {

    public var onUpdate: (() -> Void)?
    private let queue = DispatchQueue(label: "com.jonahaung.HomeForYou.Debouncer", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    @Published private var counter = 0

    public init() {
        $counter
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: self.queue)
            .sink { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    if value > 0 {
                        self.deQueue()
                    } else {
                        self.onUpdate?()
                    }
                }
            }
            .store(in: &cancellables)
    }

    public func enQueue() {
        counter += 1
    }

    public func deQueue() {
        counter = 0
    }
}
