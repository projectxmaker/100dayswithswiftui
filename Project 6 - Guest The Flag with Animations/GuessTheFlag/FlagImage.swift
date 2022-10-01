//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import Foundation
import SwiftUI

struct FlagImage: View {
    @Binding var showAnimation: Bool
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(color: .white, radius: 5, x: 0, y: 2)
            .rotation3DEffect(.degrees(showAnimation ? 360 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(showAnimation ? .interpolatingSpring(stiffness: 5, damping: 1) : nil, value: showAnimation)
    }
}
