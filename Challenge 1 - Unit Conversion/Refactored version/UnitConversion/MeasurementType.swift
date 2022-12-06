//
//  UCPickerStyle.swift
//  UnitConversion
//
//  Created by Pham Anh Tuan on 9/27/22.
//

import Foundation
import SwiftUI

struct MeasurementType: Identifiable {

    struct UnitType: Identifiable, Hashable {
        var id = UUID()
        var name: LocalizedStringKey
        var dimension: Dimension
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    var id = UUID()
    var name: LocalizedStringKey
    var unitTypes: [UnitType]
    var pickerStyle: UCPickerStyle
    var showPickerTitle: Bool
}

extension MeasurementType: Equatable {
    static func == (lhs: MeasurementType, rhs: MeasurementType) -> Bool {
        lhs.id == rhs.id
    }
}

extension MeasurementType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



