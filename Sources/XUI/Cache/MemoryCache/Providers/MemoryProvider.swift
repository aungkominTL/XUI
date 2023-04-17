
import Foundation

public extension CacheProvider {
    
    class MemoryProvider: CacheProvidable {
        @AtomicQueue
        fileprivate var cache: [String: MemoryCacheValue] = [:]
        
        public func set(key: String, value: Codable, expiresAt: Date) {
            let val = MemoryCacheValue(value: value, expiresAt: expiresAt)
            cache[key] = val
        }
        
        public func get<T: Codable>(_ type: T.Type, key: String) -> T? {
            removeExpiredValues()
            let obj = cache.first(where: {$0.key == key})
            return obj?.value.value as? T
        }
        
        public func clear() {
            cache.removeAll()
        }
    }
}

extension CacheProvider.MemoryProvider {
    private func removeExpiredValues() {
        for val in cache {
            if Date() > val.value.expiresAt {
                cache.removeValue(forKey: val.key)
            }
        }
    }
}

extension CacheProvider.MemoryProvider {
    struct MemoryCacheValue {
        var value: Codable
        var expiresAt: Date
    }
}
