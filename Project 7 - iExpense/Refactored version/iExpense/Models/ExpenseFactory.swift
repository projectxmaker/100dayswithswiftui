//
//  ExpenseFactory.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 12/10/22.
//

import Foundation

class ExpenseFactory {
    static var shared = ExpenseFactory()
    
    var items = [ExpenseItem]() {
        didSet {
            saveItemsIntoStorage()
        }
    }
    
    init() {
        loadItemsFromStorage()
    }
    
    func loadItemsFromStorage() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
            }
        }
    }
    
    func saveItemsIntoStorage() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
    
    func addExpense(_ item: ExpenseItem) {
        items.append(item)
    }
    
    func removeExpenseByIds(ids: [UUID]) {
        items = items.filter { expenseItem in
            !ids.contains(expenseItem.id)
        }
    }
}
