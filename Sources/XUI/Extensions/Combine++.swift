//
//  File.swift
//  
//
//  Created by Aung Ko Min on 19/7/23.
//

import Combine

public extension Publisher where Self.Failure == Never {
    func asyncSink(receiveValue: @escaping (@Sendable (Self.Output) async -> Void)) -> AnyCancellable {
        sink { value in
            Task {
                guard !Task.isCancelled else { return }
                await receiveValue(value)
            }
        }
    }
}

public extension AnyPublisher {
    enum AsyncError: Error {
        case finishedWithoutValue
    }
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { [unowned cancellable] result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: AsyncError.finishedWithoutValue)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
