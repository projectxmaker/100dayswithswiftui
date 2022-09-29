//
//  CircleText.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/29/22.
//

import Foundation
import SwiftUI

struct CircleText: View {
    var content: String
    var backgroundColors: [Color]
    var shadowColor: Color
    
    var body: some View {
        Text(content)
            .symbolRenderingMode(.none)
            .font(.system(size: 80))
            .frame(width: 140, height: 140)
            .background(RadialGradient(colors: backgroundColors, center: .center, startRadius: 10, endRadius: 100))
            .clipShape(Capsule())
            .shadow(color: shadowColor, radius: 10, x: 0, y: 0)
    }
}
