//
//  NotificationViewController.swift
//  Confirm
//
//  Created by wqh on 12/6/20.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import WidgetKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "refresh" {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

}
