//
//  Face.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation

struct Face: Codable, Identifiable {
    let id: UUID
    let name: String
    let picture: String
}
