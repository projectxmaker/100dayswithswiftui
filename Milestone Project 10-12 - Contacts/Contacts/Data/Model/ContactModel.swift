//
//  User.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import Foundation

struct ContactModel: Codable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [ContactFriendModel]
    
    var wrappedRegistered: String {
        registered.formatted(date: .abbreviated, time: .shortened)
    }
}
