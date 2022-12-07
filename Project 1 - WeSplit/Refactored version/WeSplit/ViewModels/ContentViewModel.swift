//
//  ContentViewModel.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    // MARK: - Published variable
    @Published var checkAmount = 0.0
    @Published var numberOfPeople = 2
    @Published var tipPercentage = 20
    
    // MARK: - Constants
    let tipPercentages = 0...100

    // MARK: - Functions
    var totalAmountOfCheck: Double {
        let tipAmount = checkAmount * Double(tipPercentage) / 100
        let grandTotal = tipAmount + checkAmount
        
        return grandTotal
    }
    
    func getAmountFormatStyle(locale: Locale) -> FloatingPointFormatStyle<Double>.Currency {
        var userCurrency: String

        if #available(iOS 16.0, *) {
            userCurrency = locale.currency?.identifier ?? "USD"
        } else {
            userCurrency = locale.currencyCode ?? "USD"
        }
        
        return FloatingPointFormatStyle<Double>.Currency(code: userCurrency)
    }
}
