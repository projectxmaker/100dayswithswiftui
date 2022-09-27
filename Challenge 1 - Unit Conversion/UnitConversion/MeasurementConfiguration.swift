//
//  MeasurementConfiguration.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/27/22.
//

import Foundation

struct MeasurementConfiguration {
    static let measurementTypes: [MeasurementType] = [
            MeasurementType(
                name: "Temperature",
                unitTypes: ["Celsius": UnitTemperature.celsius, "Fahrenheit": UnitTemperature.fahrenheit, "Kelvin": UnitTemperature.kelvin],
                pickerStyle: .segmented,
                showPickerTitle: true
            ),
            MeasurementType(
                name: "Length",
                unitTypes: ["Kilometers": UnitLength.kilometers, "Meters": UnitLength.meters, "Inches": UnitLength.inches, "Feet": UnitLength.feet, "Yards": UnitLength.yards, "Miles": UnitLength.miles],
                pickerStyle: .automatic,
                showPickerTitle: false
            )
        ]
    static let defaultUnitTypes = ["Celsius", "Fahrenheit", "Kelvin"]
    static let defaultUCPickerStyle = UCPickerStyle.segmented
    static let defaultShowPickerTitle = true
}
