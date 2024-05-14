//
//  NotificationCenterKey.swift
//  MoreUI
//
//  Created by Ryan Rudes on 11/7/21.
//

import SwiftUI

private struct NotificationCenterKey: EnvironmentKey {
    static let defaultValue = UNUserNotificationCenter.current()
}

extension EnvironmentValues {
    var notificationCenter: UNUserNotificationCenter {
        get { self[NotificationCenterKey.self] }
        set { self[NotificationCenterKey.self] = newValue }
    }
}

extension UNUserNotificationCenter {
    @available(iOS 15.0, *)
    func post(title: String,
              subtitle: String,
              body: String,
              badge: NSNumber? = nil,
              sound: UNNotificationSound? = .default,
              launchImageName: String? = nil,
              userInfo: [AnyHashable : Any] = [:],
              attachments: [UNNotificationAttachment] = [],
              categoryIdentifier: String? = nil,
              threadIdentifier: String? = nil,
              targetContentIdentifier: String? = nil,
              interruptionLevel: UNNotificationInterruptionLevel? = nil,
              relevanceScore: Double? = nil,
              options: UNAuthorizationOptions = [],
              trigger: (() -> UNNotificationTrigger)? = nil
    ) {
        _post(title: title, subtitle: subtitle, body: body, badge: badge, sound: sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments, summaryArgument: nil, summaryArgumentCount: nil, categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, interruptionLevel: interruptionLevel, relevanceScore: relevanceScore, options: options, trigger: trigger)
    }
    @available(iOS, deprecated: 15.0)
    func post(title: String,
              subtitle: String,
              body: String,
              badge: NSNumber? = nil,
              sound: UNNotificationSound? = .default,
              launchImageName: String? = nil,
              userInfo: [AnyHashable : Any] = [:],
              attachments: [UNNotificationAttachment] = [],
              summaryArgument: String? = nil,
              summaryArgumentCount: Int? = nil,
              categoryIdentifier: String? = nil,
              threadIdentifier: String? = nil,
              targetContentIdentifier: String? = nil,
              interruptionLevel: UNNotificationInterruptionLevel? = nil,
              relevanceScore: Double? = nil,
              options: UNAuthorizationOptions = [],
              trigger: (() -> UNNotificationTrigger)? = nil
    ) {
        _post(title: title, subtitle: subtitle, body: body, badge: badge, sound: sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments, summaryArgument: summaryArgument, summaryArgumentCount: summaryArgumentCount, categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, interruptionLevel: interruptionLevel, relevanceScore: relevanceScore, options: options, trigger: trigger)
    }
    
    private func _post(title: String,
                       subtitle: String,
                       body: String,
                       badge: NSNumber? = nil,
                       sound: UNNotificationSound? = .default,
                       launchImageName: String? = nil,
                       userInfo: [AnyHashable : Any] = [:],
                       attachments: [UNNotificationAttachment] = [],
                       summaryArgument: String? = nil,
                       summaryArgumentCount: Int? = nil,
                       categoryIdentifier: String? = nil,
                       threadIdentifier: String? = nil,
                       targetContentIdentifier: String? = nil,
                       interruptionLevel: UNNotificationInterruptionLevel? = nil,
                       relevanceScore: Double? = nil,
                       options: UNAuthorizationOptions = [],
                       trigger: (() -> UNNotificationTrigger)? = nil) {
        var options = options
        
        if badge != nil { options.insert(.badge) }
        if sound != nil { options.insert(.sound) }
        if sound == .defaultCritical { options.insert(.criticalAlert) }
        options.insert(.alert)
        
        requestAuthorization(options: options) { success, error in
            if success {
                print ("Authorization Granted")
            } else if let error = error {
                print (error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        content.sound = sound
        
        if let launchImageName = launchImageName {
            content.launchImageName = launchImageName
        }
        
        content.userInfo = userInfo
        content.attachments = attachments
        
        if let categoryIdentifier = categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        if let threadIdentifier = threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        
        content.targetContentIdentifier = targetContentIdentifier
        
        if let interruptionLevel = interruptionLevel {
            content.interruptionLevel = interruptionLevel
        }
        
        if let relevanceScore = relevanceScore {
            content.relevanceScore = relevanceScore
        }
        
        var computedTrigger: UNNotificationTrigger? = nil
        
        if let trigger = trigger {
            computedTrigger = trigger()
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: computedTrigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
