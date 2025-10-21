//
//  NotificationManager.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    private(set) var notifications: [AppNotification] = []
    
    func createNotification(type: NotificationType, message: String, postId: String? = nil) {
        let notification = AppNotification(type: type, message: message, postId: postId)
        notifications.insert(notification, at: 0)
    }
    
    func getNotifications() -> [AppNotification] {
        return notifications
    }
    
    func markAsRead(notificationId: String) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            var notification = notifications[index]
            notification.isRead = true
            notifications[index] = notification
        }
    }
    
    func getUnreadCount() -> Int {
        return notifications.filter { !$0.isRead }.count
    }
}

