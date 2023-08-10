//
//  Atomic.swift
//  RoomRentalDemo
//
//  Created by Aung Ko Min on 20/1/23.
//


import Foundation

@propertyWrapper public final class Atomic<T> {
    private var value: T
    private let lock: os_unfair_lock_t

    public init(wrappedValue value: T) {
        self.value = value
        self.lock = .allocate(capacity: 1)
        self.lock.initialize(to: os_unfair_lock())
    }

    deinit {
        lock.deinitialize(count: 1)
        lock.deallocate()
    }

    public var wrappedValue: T {
        get { getValue() }
        set { setValue(newValue) }
    }
    
     private func getValue() -> T {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        return value
    }

    private func setValue(_ newValue: T) {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        value = newValue
    }
}

@propertyWrapper
public struct AtomicQueue<Value> {
    private let queue = DispatchQueue(label: "com.jonahaung.AtomicQueue")
    private var value: Value
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }
}
