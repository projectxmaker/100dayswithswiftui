//
//  AddView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI

struct AddView: View {
    @StateObject var addVM = AddViewModel()

    @EnvironmentObject var expensesVM: ExpensesViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $addVM.name)

                Picker("Type", selection: $addVM.type) {
                    ForEach(ExpenseType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }

                TextField("Amount", value: $addVM.amount, format: .currency(code: expensesVM.currencyCode))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    addVM.addExpense()
                    expensesVM.loadItems()
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environmentObject(ExpensesViewModel())
    }
}
