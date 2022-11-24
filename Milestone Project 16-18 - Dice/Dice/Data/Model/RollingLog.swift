//
//  RollingLog.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

struct RollingLog: Codable, Comparable {
    let dices: Double
    let posibilities: Double
    let result: String
    let sumOfResult: Int
    let highestResult: Int
    let lowestResult: Int
    var createdAt = Date.now
    
    static func < (lhs: RollingLog, rhs: RollingLog) -> Bool {
        lhs.result < rhs.result
    }
}
