//
//  AddView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = ExpenseType.personal
    @State private var amount = 0.0
    
    @EnvironmentObject var expensesVM: ExpensesViewModel

    @Environment(\.dismiss) var dismiss

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: expensesVM.currencyCode))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expensesVM.items.append(item)
                    
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
