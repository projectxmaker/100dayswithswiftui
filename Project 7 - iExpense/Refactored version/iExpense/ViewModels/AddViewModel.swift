//
//  AddViewModel.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 12/10/22.
//

import Foundation
import SwiftUI

@MainActor
class AddViewModel: ObservableObject {
    @Published var name = ""
    @Published var type = ExpenseType.personal
    @Published var amount = 0.0
    
    var expenseFactory = ExpenseFactory.shared
    
    func addExpense() {
        expenseFactory.addExpense(
            ExpenseItem(name: name, type: type, amount: amount)
        )
    }
}
