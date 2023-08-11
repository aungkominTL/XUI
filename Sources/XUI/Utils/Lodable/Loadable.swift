//
//  Loadable.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Foundation
import SwiftUI

//public typealias LoadableSubject<Value> = Binding<Loadable<Value>>

public enum Loadable<T> {
    
    case intro
    case loading
    case loaded(value: T, isLoadingMore: Bool)
    case failed(Error)
    
    public var value: T? {
        switch self {
        case let .loaded(value, _): return value
        default: return nil
        }
    }
    public var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

public extension Loadable {
    
    var canLoadMore: Bool {
        switch self {
        case .loaded( _, let isLoadingMore):
            return !isLoadingMore
        default:
            return false
        }
    }
    
    func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .intro: return .intro
            case let .failed(error): return .failed(error)
            case let .loaded(value, isLoadingMore):
                return .loaded(value: try transform(value), isLoadingMore: isLoadingMore)
            case .loading: return .loading
            }
        } catch {
            return .failed(error)
        }
    }
}

public protocol SomeOptional {
    associatedtype Wrapped
    func unwrap() throws -> Wrapped
}

public struct ValueIsMissingError: Error {
    var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}

extension Optional: SomeOptional {
    public func unwrap() throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw ValueIsMissingError()
        }
    }
}

public extension Loadable where T: SomeOptional {
    func unwrap() -> Loadable<T.Wrapped> {
        map { try $0.unwrap() }
    }
}

extension Loadable: Equatable where T: Equatable {
    public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.intro, .intro): return true
        case (.loading, .loading): return true
        case let (.loaded(oneA, oneB), .loaded(twoA, twoB)): return oneA == twoA && oneB == twoB
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
