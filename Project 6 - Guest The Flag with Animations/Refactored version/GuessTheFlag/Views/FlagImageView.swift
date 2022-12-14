//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import Foundation
import SwiftUI

struct FlagImageView: View {
    var showAnimation: Bool
    var isNotChosen: Bool
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(color: .white, radius: 5, x: 0, y: 2)
            .opacity(isNotChosen ? 0.25 : 1)
            .scaleEffect(isNotChosen ? 0 : 1)
            .rotation3DEffect(.degrees(isNotChosen ? 360 : 0), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(showAnimation ? 360 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(.interpolatingSpring(stiffness: 5, damping: 3), value: isNotChosen)
            .animation(.interpolatingSpring(stiffness: 5, damping: 1), value: showAnimation)
    }
}

struct FlagImageView_Preview: PreviewProvider {
    static var previews: some View {
        FlagImageView(showAnimation: true, isNotChosen: false, imageName: "France")
    }
}
