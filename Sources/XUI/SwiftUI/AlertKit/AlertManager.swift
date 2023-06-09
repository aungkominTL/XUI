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
    
}
