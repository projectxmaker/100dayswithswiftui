//
//  RollingLog.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

struct RollingLog: Codable {
    let dices: Int
    let posibilities: Int
    let result: String
    let sumOfResult: Int
    var createdAt = Date.now
}
