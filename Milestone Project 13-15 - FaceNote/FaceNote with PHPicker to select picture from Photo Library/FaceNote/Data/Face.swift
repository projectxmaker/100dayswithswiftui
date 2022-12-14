//
//  Face.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation
import MapKit

struct Face: Codable, Identifiable, Equatable, Comparable {
    var id: UUID
    var name: String
    var picture: String
    var thumbnail: String
    var latitude: Double
    var longitude: Double
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }
}
