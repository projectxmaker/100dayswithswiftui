//
//  ContentView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/10/22.
//

import SwiftUI

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

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
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                        Text(item.amount, format: .currency(code: currencyCode))
                            .foregroundColor(getColorByAmount(item.amount))
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    }
                }
                .onDelete(perform: removeItems)
            }
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
