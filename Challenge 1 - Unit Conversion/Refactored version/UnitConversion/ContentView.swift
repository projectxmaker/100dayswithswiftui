//
//  ContentView.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/25/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedMeasurementType = MeasurementConfiguration.defaultMeasurementType
    @State private var inputUnit = MeasurementConfiguration.defaultMeasurementType.unitTypes[0]
    @State private var outputUnit = MeasurementConfiguration.defaultMeasurementType.unitTypes[0]
    @State private var amount: Double = 0
    @FocusState private var amountTextFieldIsFocused: Bool
    
    let inputUnitTitle: LocalizedStringKey = "Input Unit"
    let outputUnitTitle: LocalizedStringKey = "Output Unit"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Measurement Types", selection: $selectedMeasurementType) {
                        ForEach(MeasurementConfiguration.measurementTypes, id: \.self) { measurementType in
                            Text(measurementType.name)
                        }
                    }
                    .onChange(of: selectedMeasurementType) { index in
                        inputUnit = selectedMeasurementType.unitTypes[0]
                        outputUnit = selectedMeasurementType.unitTypes[0]
                    }
                }
                
                Section {
                    UCPickerView(pickerTitle: inputUnitTitle, measurementType: selectedMeasurementType, unit: $inputUnit)
                } header: {
                    Text(inputUnitTitle)
                }
                
                Section {
                    UCPickerView(pickerTitle: outputUnitTitle, measurementType: selectedMeasurementType, unit: $outputUnit)
                } header: {
                    Text(outputUnitTitle)
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
    
    // MARK: - Extra Funcs
    var result: Double {
        let input = Measurement(value: amount, unit: inputUnit.dimension)
        let output = input.converted(to: outputUnit.dimension)
        
        return output.value
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
