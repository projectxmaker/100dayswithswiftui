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
    
    @FocusState private var amountTextFieldIsFocused: Bool
    
    let tipPercentages = 0...100
    var totalPerPerson: Double {
        totalAmountOfCheck / Double(numberOfPeople)
    }
    
    var totalAmountOfCheck: Double {
        let tipAmount = checkAmount * Double(tipPercentage) / 100
        let grandTotal = tipAmount + checkAmount
        
        return grandTotal
    }
    
    var currencyFormatter: FloatingPointFormatStyle<Double>.Currency {
        var userCurrency: String

        if #available(iOS 16.0, *) {
            userCurrency = Locale.current.currency?.identifier ?? "USD"
        } else {
            userCurrency = Locale.current.currencyCode ?? "USD"
        }
        
        return FloatingPointFormatStyle<Double>.Currency(code: userCurrency)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyFormatter)
                        .keyboardType(.decimalPad)
                        .focused($amountTextFieldIsFocused)
                    
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
                } header: {
                    Text("How much tip do you want to leave")
                }
                
                Section {
                    Text(totalAmountOfCheck, format: currencyFormatter)
                } header: {
                    Text("Total amount for the check")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyFormatter)
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountTextFieldIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
