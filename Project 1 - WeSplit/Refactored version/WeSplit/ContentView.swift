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
    
    @Environment(\.locale) var currentLocale

    @FocusState private var amountTextFieldIsFocused: Bool
    
    let tipPercentages = 0...100

    var totalAmountOfCheck: Double {
        let tipAmount = checkAmount * Double(tipPercentage) / 100
        let grandTotal = tipAmount + checkAmount
        
        return grandTotal
    }
    
    var amountFormatStyle: FloatingPointFormatStyle<Double>.Currency {
        var userCurrency: String

        if #available(iOS 16.0, *) {
            userCurrency = currentLocale.currency?.identifier ?? "USD"
        } else {
            userCurrency = currentLocale.currencyCode ?? "USD"
        }
        
        return FloatingPointFormatStyle<Double>.Currency(code: userCurrency)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: amountFormatStyle)
                        .id(amountFormatStyle)
                        .keyboardType(.decimalPad)
                        .focused($amountTextFieldIsFocused)
                    
                    NumberOfPeopleView(numberOfPeople: $numberOfPeople)
                }

                Section {
                    TipPercentageView(tipPercentages: tipPercentages, tipPercentage: $tipPercentage)
                } header: {
                    Text("How much tip do you want to leave")
                }
                
                Section {
                    AmountOfCheckView(
                        totalAmountOfCheck: totalAmountOfCheck,
                        format: amountFormatStyle,
                        tipPercentage: tipPercentage
                    )
                } header: {
                    Text("Total amount for the check")
                }
                
                Section {
                    AmounPerPersonView(
                        format: amountFormatStyle,
                        totalAmountOfCheck: totalAmountOfCheck,
                        numberOfPeople: $numberOfPeople)
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
        Group {
            ContentView()
            
            ContentView()
                .environment(\.locale, .init(identifier: "vi_VN")  )
            
            ContentView()
                .environment(\.locale, .init(identifier: "fr_FR"))
        }
    }
}
