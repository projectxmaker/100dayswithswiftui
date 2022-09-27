//
//  UCPickerStyle.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/27/22.
//

import Foundation

struct MeasurementType {
    var name: String
    var unitTypes: [String : Dimension]
    var pickerStyle: UCPickerStyle
    var showPickerTitle: Bool
}
