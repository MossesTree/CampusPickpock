//
//  Notification.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import Foundation

enum NotificationType {
    case comment
    case reply
    case system
}

struct AppNotification {
    let id: String
    let type: NotificationType
    let message: String
    let postId: String?
    var isRead: Bool
    let createdAt: Date
    
    init(id: String = UUID().uuidString,
         type: NotificationType,
         message: String,
         postId: String? = nil,
         isRead: Bool = false,
         createdAt: Date = Date()) {
        self.id = id
        self.type = type
        self.message = message
        self.postId = postId
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

