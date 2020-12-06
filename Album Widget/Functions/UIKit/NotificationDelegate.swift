//
//  NotificationDelegate.swift
//  Album Widget
//
//  Created by wqh on 12/5/20.
//

import SwiftUI
import WidgetKit

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "refresh":
            WidgetCenter.shared.reloadAllTimelines()
        default:
            break
        }
    }
}
