//
//  Comment.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import Foundation

struct Comment {
    let id: String
    let content: String
    let authorId: String
    let authorName: String
    let postId: String
    let isPrivate: Bool
    let createdAt: Date
    let parentCommentId: String?
    
    init(id: String = UUID().uuidString,
         content: String,
         authorId: String,
         authorName: String,
         postId: String,
         isPrivate: Bool = false,
         createdAt: Date = Date(),
         parentCommentId: String? = nil) {
        self.id = id
        self.content = content
        self.authorId = authorId
        self.authorName = authorName
        self.postId = postId
        self.isPrivate = isPrivate
        self.createdAt = createdAt
        self.parentCommentId = parentCommentId
    }
}

