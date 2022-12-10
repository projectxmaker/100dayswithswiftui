//
//  ExpenseListView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 12/10/22.
//

import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject var expenseVM: ExpensesViewModel
    
    var title: String
    var expenses: [ExpenseItem]
    
    var body: some View {
        if !expenses.isEmpty {
            Section(title) {
                ForEach(expenses, id: \.id) { item in
                    ExpenseRowView(item: item)
                }
                .onDelete { indexSet in
                    var arrItemIds = [UUID]()
                    for eachIndex in indexSet {
                        arrItemIds.append(expenses[eachIndex].id)
                    }
                    
                    expenseVM.removeItemsByIds(ids: arrItemIds)
                }
            }
        }
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ExpenseListView(title: "Expense", expenses: ExpensesViewModel.sampleExpenses)
                .environmentObject(ExpensesViewModel())
        }
    }
}
