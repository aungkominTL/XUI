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
    @MainActor func reloadUI()
}

public extension ViewModel {
    @MainActor func showAlert(_ alert: _Alert) {
        self.loading = false
        self.alert = alert
        reloadUI()
    }
    @MainActor func setLoading(_ value: Bool) {
        loading = value
        reloadUI()
    }
    @MainActor func canPerform() -> Bool {
        !loading
    }
    @MainActor func reloadUI() {
    }
}
