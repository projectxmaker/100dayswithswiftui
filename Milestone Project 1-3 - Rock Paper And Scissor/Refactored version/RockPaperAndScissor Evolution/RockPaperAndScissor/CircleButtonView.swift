//
//  CircleText.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/29/22.
//

import Foundation
import SwiftUI

struct CircleButtonView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var item: String
    var backgroundColors: [Color]
    var shadowColor: Color
    
    var body: some View {
        Button {
            vm.handleButtonTapped(tappedItem: item)
        } label: {
            CircleTextView(
                item: item,
                backgroundColors: backgroundColors,
                shadowColor: shadowColor)
        }

    }
}

struct CircleButtonView_Preview: PreviewProvider {
    struct SampleView: View {
        var body: some View {
            CircleButtonView(
                item: "🖐",
                backgroundColors: [.blue, .red],
                shadowColor: .yellow
            )
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
