//
//  Country.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation
import SwiftUI

struct Country: Identifiable {
    var id = UUID()
    var name: LocalizedStringKey
    var imageName: String
}
