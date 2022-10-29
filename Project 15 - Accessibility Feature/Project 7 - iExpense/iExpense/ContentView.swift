//
//  ContentView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var currencyCode: String {
        var code: String
        
        if #available(iOS 16, *) {
            code = Locale.current.currency?.identifier ?? "USD"
        } else {
            code = Locale.current.currencyCode ?? "USD"
        }
        
        return code
    }
    
    // MARK: - Extra Funcs
    func removeItemsByIds(ids: [UUID]) {
        expenses.items = expenses.items.filter { expenseItem in
            !ids.contains(expenseItem.id)
        }
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
    
    func displayList() -> some View {
        let businessExpenses = expenses.items.filter { expenseItem in
            expenseItem.type == ExpenseType.business
        }
        
        let personalExpenses = expenses.items.filter { expenseItem in
            expenseItem.type == ExpenseType.personal
        }
        
        return List {
            if !businessExpenses.isEmpty {
                displayExpenseListByType(title: ExpenseType.business.rawValue, expenses: businessExpenses)
            }
            
            if !personalExpenses.isEmpty {
                displayExpenseListByType(title: ExpenseType.personal.rawValue, expenses: personalExpenses)
            }
        }
    }
    
    func displayExpenseListByType(title: String, expenses: [ExpenseItem]) -> some View {
        Section(title) {
            ForEach(expenses, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type.rawValue)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: currencyCode))
                        .foregroundColor(getColorByAmount(item.amount))
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                }
                .accessibilityElement()
                .accessibilityLabel("\(item.amount) of \(item.name)")
                .accessibilityHint(item.type.rawValue)
            }
            .onDelete { indexSet in
                var arrItemIds = [UUID]()
                for eachIndex in indexSet {
                    arrItemIds.append(expenses[eachIndex].id)
                }
                
                removeItemsByIds(ids: arrItemIds)
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            displayList()
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("iExpense")
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses, currencyCode: currencyCode)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
