//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI

enum ExpenseType: LocalizedStringKey, Codable, CaseIterable {
    case business = "Business"
    case personal = "Personal"
}

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
}
