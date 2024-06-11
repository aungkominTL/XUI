//
//  File.swift
//  
//
//  Created by Aung Ko Min on 26/5/24.
//

import Foundation

public protocol ViewModel: AnyObject {
    var alert: _Alert? { get set }
    var loading: Bool { get set }
    @MainActor func showAlert(_ alert: _Alert)
    @MainActor func setLoading(_ value: Bool)
}

public extension ViewModel {
    @MainActor func showAlert(_ alert: _Alert) {
        self.loading = false
        self.alert = alert
    }
    @MainActor func setLoading(_ value: Bool) {
        loading = value
    }
    @MainActor func canPerform() -> Bool {
        !loading
    }
}
