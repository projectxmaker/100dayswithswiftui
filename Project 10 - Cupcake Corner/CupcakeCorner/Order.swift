//
//  Order.swift
//  CupcakeCorner
//
//  Created by Pham Anh Tuan on 10/19/22.
//

import SwiftUI

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    func isValidInput(_ val: String) -> Bool {
        !val.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var hasValidAddress: Bool {
        if !isValidInput(name) || !isValidInput(streetAddress) || !isValidInput(city) || !isValidInput(zip) {
            return false
        }

        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
}
