//
//  Post.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

enum PostType {
    case lost
    case found
}

struct Post {
    let id: String
    let postingId: Int?
    let title: String
    let content: String
    let location: String?
    let images: [UIImage]
    let authorId: String
    let authorName: String
    let isHidden: Bool
    let createdAt: Date
    var commentCount: Int
    let type: PostType
    
    init(id: String = UUID().uuidString, 
         postingId: Int? = nil,
         title: String, 
         content: String, 
         location: String? = nil,
         images: [UIImage] = [], 
         authorId: String, 
         authorName: String, 
         isHidden: Bool = false, 
         createdAt: Date = Date(),
         commentCount: Int = 0,
         type: PostType = .lost) {
        self.id = id
        self.postingId = postingId
        self.title = title
        self.content = content
        self.location = location
        self.images = images
        self.authorId = authorId
        self.authorName = authorName
        self.isHidden = isHidden
        self.createdAt = createdAt
        self.commentCount = commentCount
        self.type = type
    }
}

