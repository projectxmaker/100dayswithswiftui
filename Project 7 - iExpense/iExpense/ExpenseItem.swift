//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
