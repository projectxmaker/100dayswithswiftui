//
//  CircleText.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/29/22.
//

import Foundation
import SwiftUI

struct CircleTextView: View {
    var item: String
    var backgroundColors: [Color]
    var shadowColor: Color
    
    var body: some View {
        Text(item)
            .symbolRenderingMode(.none)
            .font(.system(size: 80))
            .frame(width: 140, height: 140)
            .background(RadialGradient(colors: backgroundColors, center: .center, startRadius: 10, endRadius: 100))
            .clipShape(Capsule())
            .shadow(color: shadowColor, radius: 10, x: 0, y: 0)
    }
}

struct CircleText_Preview: PreviewProvider {
    struct SampleView: View {
        var body: some View {
            CircleTextView(
                item: "✊",
                backgroundColors: [.blue, .red],
                shadowColor: .yellow
            )
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
