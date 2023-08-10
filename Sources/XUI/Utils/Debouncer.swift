//
//  Debouncer.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 17/5/23.
//

import Foundation
import Combine

public class Debouncer: ObservableObject {

    @Published private var counter = -1
    private var cancellables = Set<AnyCancellable>()
    @MainActor public var onUpdate: (() -> Void) = {}
    private let queue = DispatchQueue(label: "com.jonahaung.debouncer")
    private var isFirstTime = true
    public init() {
        $counter
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: queue)
            .sink { [weak self] value in
                guard let self else { return }
                guard self.isFirstTime == false else {
                    self.isFirstTime = false
                    return
                }
                if value == 0 {
                    await self.onUpdate()
                } else {
                    self.deQueue()
                }
            }
            .store(in: &cancellables)
    }

    public func enQueue() {
        counter += 1
    }

    private func deQueue() {
        counter = 0
        print("deque")
    }
}

