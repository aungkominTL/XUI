//
//  AlertManager.swift
//  XUI
//
//  Created by Aung Ko Min on 27/1/23.
//

import SwiftUI

public class AlertManager: ObservableObject {

    @Published public var alertItem: AlertItem?
    @Published public var actionSheetItem: ActionSheetItem?
    
    public init() { }

    @MainActor public func show(dismiss: AlertItem.Dismiss) {
        alertItem = AlertItem(dismiss: dismiss, primarySecondary: Optional.none)
    }
    @MainActor public func show(primarySecondary: AlertItem.PrimarySecondary) {
        alertItem = AlertItem(dismiss: Optional.none, primarySecondary: primarySecondary)
    }
    @MainActor public func showActionSheet(_ sheet: ActionSheetItem.DefaultActionSheet) {
        actionSheetItem = ActionSheetItem(defaultActionSheet: sheet)
    }
    @MainActor public func show(_ error: Error, _ action: @escaping () -> Void) {
        self.show(dismiss: .error(message: error.localizedDescription, dismissButton: .cancel(action)))
    }
    @MainActor public func showSuccess(_ message: String, _ action: @escaping () -> Void) {
        self.showActionSheet(.custom(title: "Success", message: message, buttons: [.cancel(action)]))
    }
    @MainActor public func showActionSheet(_ error: Error, _ action: @escaping () -> Void) {
        self.showActionSheet(.custom(title: "Error", message: error.localizedDescription, buttons: [.cancel(action)]))
    }
}
