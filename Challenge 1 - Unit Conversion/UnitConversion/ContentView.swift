//
//  ContentView.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/25/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var measurementTypeIndex: Int = 0
    @State private var inputUnit: String = ""
    @State private var outputUnit: String = ""
    @State private var amount: Double = 0
    @FocusState private var amountTextFieldIsFocused: Bool

    @State private var inputUnitPicker: any View = Color(.red)
    @State private var outputUnitPicker: any View = Color(.red)
    @State private var unitTypes = MeasurementConfiguration.defaultUnitTypes
    @State private var ucPickerStyle = MeasurementConfiguration.defaultUCPickerStyle
    
    let measurementTypes = MeasurementConfiguration.measurementTypes
    
    let inputUnitTitle = "Input Unit"
    let outputUnitTitle = "Output Unit"

    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    Picker("Measurement Types", selection: $measurementTypeIndex) {
                        ForEach(0..<measurementTypes.count, id: \.self) { index in
                            Text(measurementTypes[index].name)
                        }
                    }
                    .onChange(of: measurementTypeIndex) { index in
                        let currentMeasurementType = measurementTypes[measurementTypeIndex]
                        unitTypes = Array(currentMeasurementType.unitTypes.keys)
                        ucPickerStyle = currentMeasurementType.pickerStyle
                    }
                }
                
                Section {
                    UCPickerView(pickerTitle: inputUnitTitle, unit: $inputUnit, pickerStyle: $ucPickerStyle, unitTypes: $unitTypes)
                } header: {
                    Text(inputUnitTitle)
                }
                
                Section {
                    UCPickerView(pickerTitle: outputUnitTitle, unit: $outputUnit, pickerStyle: $ucPickerStyle, unitTypes: $unitTypes)
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
        let measurementType = measurementTypes[measurementTypeIndex]
        guard
            let inputUnit = measurementType.unitTypes[inputUnit],
            let outputUnit = measurementType.unitTypes[outputUnit]
        else { return 0 }
        
        let input = Measurement(value: amount, unit: inputUnit)
        let output = input.converted(to: outputUnit)
        
        return output.value
    }
    
    func getUnitTypes() -> [String] {
        Array(measurementTypes[measurementTypeIndex].unitTypes.keys)
    }
    
    func getPickerStyle() -> UCPickerStyle {
        measurementTypes[measurementTypeIndex].pickerStyle
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
