//
//  AmounPerPersonView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct AmounPerPersonView: View {
    var format: FloatingPointFormatStyle<Double>.Currency
    var totalAmountOfCheck: Double
    @Binding var numberOfPeople: Int
    
    var totalPerPerson: Double {
        totalAmountOfCheck / Double(numberOfPeople)
    }

    var body: some View {
        Text(totalPerPerson, format: format)
    }
}

struct AmounPerPersonView_Previews: PreviewProvider {
    struct SampleView: View {
        var totalAmountOfCheck: Double = 100.55
        @State var numberOfPeople: Int = 2
        
        var body: some View {
            AmounPerPersonView(
                format: FloatingPointFormatStyle<Double>.Currency(code: "USD"),
                totalAmountOfCheck: totalAmountOfCheck, numberOfPeople: $numberOfPeople
            )
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
