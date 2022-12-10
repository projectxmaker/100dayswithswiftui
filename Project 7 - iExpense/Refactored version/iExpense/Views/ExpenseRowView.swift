//
//  ExpenseRowView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 12/10/22.
//

import SwiftUI

struct ExpenseRowView: View {
    @EnvironmentObject var expenseVM: ExpensesViewModel
    var item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type.rawValue)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: expenseVM.currencyCode))
                .foregroundColor(expenseVM.getColorByAmount(item.amount))
                .shadow(color: .gray, radius: 1, x: 1, y: 1)
        }
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ForEach(ExpensesViewModel.sampleExpenses) { item in
                ExpenseRowView(item: item)
                    .environmentObject(ExpensesViewModel())
            }
        }
    }
}
