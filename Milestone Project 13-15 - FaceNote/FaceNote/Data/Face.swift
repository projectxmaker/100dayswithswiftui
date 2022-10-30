//
//  Face.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation

struct Face: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    var picture: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
