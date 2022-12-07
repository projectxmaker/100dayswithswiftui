//
//  AmountOfCheckView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct AmountOfCheckView: View {
    var totalAmountOfCheck: Double
    var format: FloatingPointFormatStyle<Double>.Currency
    var tipPercentage: Int
    
    var body: some View {
        Text(totalAmountOfCheck, format: format)
            .foregroundColor(tipPercentage == 0 ? .red : .primary)
    }
}

struct AmountOfCheckView_Previews: PreviewProvider {
    static var previews: some View {
        AmountOfCheckView(
            totalAmountOfCheck: 100,
            format: FloatingPointFormatStyle<Double>.Currency(code: "USD"),
            tipPercentage: 10
        )
    }
}
