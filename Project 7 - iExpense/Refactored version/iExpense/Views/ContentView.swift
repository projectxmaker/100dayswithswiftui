//
//  ContentView.swift
//  iExpense
//
//  Created by Pham Anh Tuan on 10/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ExpensesViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    ForEach(ExpenseType.allCases, id: \.self) { type in
                        ExpenseListView(title: type.rawValue, expenses: vm.getExpensesList(type: type))
                    }
                }
            }
            .sheet(isPresented: $vm.showingAddExpense) {
                AddView()
            }
            .toolbar {
                Button {
                    vm.showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("iExpense")
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ExpensesViewModel()
        
        var body: some View {
            ContentView()
        }
    }
    
    static var previews: some View {
        Group {
            SampleView()
            
            SampleView()
                .environment(\.locale, Locale(identifier: "vi_VN"))
        }
    }
}
