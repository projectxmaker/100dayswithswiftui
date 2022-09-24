//
//  ContentView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let tipAmount = checkAmount * Double(tipPercentage) / 100
        let grandTotal = tipAmount + checkAmount
        let amountPerPerson = grandTotal / Double(numberOfPeople)
        
        return amountPerPerson
    }
    
    var localeCurrency: String {
        var userCurrency: String
        
        if #available(iOS 16.0, *) {
            userCurrency = Locale.current.currency?.identifier ?? "USD"
        } else {
            userCurrency = Locale.current.currencyCode ?? "USD"
        }
        
        return userCurrency
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: localeCurrency))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100, id:\.self) { element in
                            Text("\(element) people")
                        }
                    }
                }

                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) { element in
                            Text(element, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: localeCurrency))
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
