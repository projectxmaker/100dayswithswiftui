//
//  User.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import Foundation

struct User: Codable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
    
    var wrappedRegistered: String {
        guard let val = try? Date(registered, strategy: .iso8601).formatted(date: .abbreviated, time: .shortened) else { return "" }
        
        return val
    }
}
