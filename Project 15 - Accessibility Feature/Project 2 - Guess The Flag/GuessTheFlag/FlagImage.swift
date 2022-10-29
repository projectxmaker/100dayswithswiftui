//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import Foundation
import SwiftUI

struct FlagImage: View {
    var imageName: String
    var accessibilityLabel: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(color: .white, radius: 5, x: 0, y: 2)
            .accessibilityLabel(accessibilityLabel)
    }
}
