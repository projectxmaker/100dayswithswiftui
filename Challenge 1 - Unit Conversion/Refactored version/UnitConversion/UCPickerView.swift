//
//  UCPickerView.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/27/22.
//

import SwiftUI
import Foundation

enum UCPickerStyle {
    case segmented
    case automatic
}

struct UCPickerView: View {
    var pickerTitle: LocalizedStringKey
    var measurementType: MeasurementType
    @Binding var unit: MeasurementType.UnitType
    
    var body: some View {
        let picker = Picker(measurementType.showPickerTitle ? pickerTitle : "", selection: $unit) {
            ForEach(measurementType.unitTypes, id: \.self) { unitType in
                Text(unitType.name)
            }
        }
        
        switch measurementType.pickerStyle {
        case .segmented:
            picker.pickerStyle(.segmented)
        case .automatic:
            picker.pickerStyle(.automatic)
        }
    }
}

struct UCPickerView_Preview: PreviewProvider {
    struct ContentView: View {
        @State var unit = MeasurementConfiguration.defaultMeasurementType.unitTypes[0]
        
        var body: some View {
            UCPickerView(pickerTitle: "Length", measurementType: MeasurementConfiguration.defaultMeasurementType, unit: $unit)
        }
    }
    
    
    static var previews: some View {
        ContentView()
    }
}
