//
//  ContentView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    @Environment(\.locale) var locale

    @FocusState private var amountTextFieldIsFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $vm.checkAmount, format: vm.getAmountFormatStyle(locale: locale))
                        .id(vm.getAmountFormatStyle(locale: locale))
                        .keyboardType(.decimalPad)
                        .focused($amountTextFieldIsFocused)
                    
                    NumberOfPeopleView(numberOfPeople: $vm.numberOfPeople)
                }

                Section {
                    TipPercentageView(tipPercentages: vm.tipPercentages, tipPercentage: $vm.tipPercentage)
                } header: {
                    Text("How much tip do you want to leave")
                }
                
                Section {
                    AmountOfCheckView(
                        totalAmountOfCheck: vm.totalAmountOfCheck,
                        format: vm.getAmountFormatStyle(locale: locale),
                        tipPercentage: vm.tipPercentage
                    )
                } header: {
                    Text("Total amount for the check")
                }
                
                Section {
                    AmounPerPersonView(
                        format: vm.getAmountFormatStyle(locale: locale),
                        totalAmountOfCheck: vm.totalAmountOfCheck,
                        numberOfPeople: $vm.numberOfPeople)
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
                .environment(\.locale, .init(identifier: "th_TH"))
        }
    }
}
