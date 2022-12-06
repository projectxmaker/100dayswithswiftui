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
                unitTypes: [
                    .init(name: "Celsius", dimension: UnitTemperature.celsius),
                    .init(name: "Fahrenheit", dimension: UnitTemperature.fahrenheit),
                    .init(name: "Kelvin", dimension: UnitTemperature.kelvin)
                ],
                pickerStyle: .segmented,
                showPickerTitle: true
            ),
            MeasurementType(
                name: "Length",
                unitTypes: [
                    .init(name: "Kilometers", dimension: UnitLength.kilometers),
                    .init(name: "Meters", dimension: UnitLength.meters),
                    .init(name: "Inches", dimension: UnitLength.inches),
                    .init(name: "Feet", dimension: UnitLength.feet),
                    .init(name: "Yards", dimension: UnitLength.yards),
                    .init(name: "Miles", dimension: UnitLength.miles)
                ],
                pickerStyle: .automatic,
                showPickerTitle: false
            )
        ]
    
    static let defaultMeasurementType = MeasurementConfiguration.measurementTypes[0]
}
