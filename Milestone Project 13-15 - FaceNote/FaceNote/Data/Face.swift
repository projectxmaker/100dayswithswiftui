//
//  Face.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation

struct Face: Codable, Identifiable, Equatable, Comparable {
    let id: UUID
    var name: String
    var picture: String
    var thumbnail: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }
}
