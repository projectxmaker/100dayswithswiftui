//
//  Card.swift
//  Flashzilla
//
//  Created by Pham Anh Tuan on 11/12/22.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
