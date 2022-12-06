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
    var pickerStyle: UCPickerStyle
    var unitTypes: [String]
    
    @Binding var unit: String
    
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

struct UCPickerView_Preview: PreviewProvider {
    struct ContentView: View {
        @State var unit: String = "three"
        
        var body: some View {
            UCPickerView(pickerTitle: "Length", showPickerTitle: true, pickerStyle: .automatic, unitTypes: ["one", "two", "three"], unit: $unit)
        }
    }
    
    
    static var previews: some View {
        ContentView()
    }
}
