//
//  TipPercentageView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct TipPercentageView: View {
    var tipPercentages: ClosedRange<Int>
    @Binding var tipPercentage: Int
    
    var body: some View {
        Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(tipPercentages, id: \.self) { element in
                Text(element, format: .percent)
            }
        }
    }
}

struct TipPercentageView_Previews: PreviewProvider {
    struct SampleView: View {
        @State var tipPercentage: Int = 10
        
        var body: some View {
            TipPercentageView(tipPercentages: 0...100, tipPercentage: $tipPercentage)
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
