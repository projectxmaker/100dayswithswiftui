//
//  ContentView.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/25/22.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "Fahrenheit"
    @State private var outputUnit = "Fahrenheit"
    @State private var amount: Double = 0
    @FocusState private var amountTextFieldIsFocused: Bool
    
    let units = ["Celsius": UnitTemperature.celsius, "Fahrenheit": UnitTemperature.fahrenheit, "Kelvin": UnitTemperature.kelvin]
    
    var result: Double {
        guard
            let inputUnit = units[inputUnit],
            let outputUnit = units[outputUnit]
        else { return 0 }
        
        let input = Measurement(value: amount, unit: inputUnit)
        let output = input.converted(to: outputUnit)
        
        return output.value
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(Array(units.keys), id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Unit")
                }
                
                Section {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(Array(units.keys), id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Unit")
                }

                Section {
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountTextFieldIsFocused)
                } header: {
                    Text("Amount")
                }
                
                Section {
                    Text(result, format: .number)
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Unit Conversion")
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
