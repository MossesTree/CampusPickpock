//
//  User.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import Foundation

struct User {
    let id: String
    let name: String
    let email: String
    let createdAt: Date
    
    init(id: String = UUID().uuidString, name: String, email: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }
}

