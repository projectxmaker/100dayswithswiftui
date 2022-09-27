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
    var pickerTitle: String
    var showPickerTitle: Bool
    
    @Binding var unit: String
    @Binding var pickerStyle: UCPickerStyle
    @Binding var unitTypes: [String]
    
    var body: some View {
        let picker = Picker(showPickerTitle ? pickerTitle : "", selection: $unit) {
            ForEach(unitTypes, id: \.self) { unitTypeKey in
                Text(unitTypeKey)
            }
        }
        
        switch pickerStyle {
        case .segmented:
            picker.pickerStyle(.segmented)
        case .automatic:
            picker.pickerStyle(.automatic)
        }
    }
}
