//
//  Expenses.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI

@MainActor
class ExpensesViewModel: ObservableObject {
    var expenseFactory = ExpenseFactory.shared
    
    @Published var items = [ExpenseItem]()
    @Published var showingAddExpense = false
    
    var currencyCode: String {
        var code: String
        
        if #available(iOS 16, *) {
            code = Locale.current.currency?.identifier ?? "USD"
        } else {
            code = Locale.current.currencyCode ?? "USD"
        }
        
        return code
    }
    
    init() {
        loadItems()
    }
    
    // MARK: - Extra Funcs
    func loadItems() {
        items = expenseFactory.items
    }
    
    func removeItemsByIds(ids: [UUID]) {
        expenseFactory.removeExpenseByIds(ids: ids)
    }
    
    func getColorByAmount(_ amount: Double) -> Color {
        var color: Color
        
        switch amount {
        case 0..<10:
            color = Color(.green)
        case 10..<100:
            color = Color(.yellow)
        case 100...:
            color = Color(.red)
        default:
            color = Color(.purple)
        }
        
        return color
    }
    
    func getExpensesList(type: ExpenseType) -> [ExpenseItem] {
        let expenses = items.filter { expenseItem in
            expenseItem.type == type
        }
        
        return expenses
    }
    
    // MARK: - Sample data
    static var sampleExpenses: [ExpenseItem] {
        [
            ExpenseItem(name: "Item 1", type: .business, amount: 5),
            ExpenseItem(name: "Item 2", type: .business, amount: 40),
            ExpenseItem(name: "Item 3", type: .business, amount: 130),
            ExpenseItem(name: "Item 4", type: .personal, amount: 3),
            ExpenseItem(name: "Item 5", type: .personal, amount: 150),
            ExpenseItem(name: "Item 6", type: .personal, amount: 80)
        ]
    }
}
