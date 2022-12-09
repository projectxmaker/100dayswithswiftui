//
//  MGPicker.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGPicker: View {
    var title: String
    var options: [Int]
    var selectFrameWidth: CGFloat
    var selectFrameHeight: CGFloat
    var selectFrameOffsetX: CGFloat
    var selectFrameOffsetY: CGFloat
    @Binding var selectedOption: Int
    @Binding var showOptionList: Bool
    var onSelect: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
            
            Spacer()
            
            HStack {
                Text("\(selectedOption)")
                    .font(.system(size: 18))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                    .frame(width: 50, height: 20, alignment: .trailing)
                
                Image(systemName: "list.number")
                    .scaleEffect(CGSize(width: 1, height: 1))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
            }
            .gesture (
                TapGesture(count: 1)
                    .onEnded { _ in
                        onSelect()
                    }
            )
            .overlay {
                if showOptionList == true {
                    MGSelector(
                        options: options,
                        width: selectFrameWidth,
                        height: selectFrameHeight,
                        offsetX: selectFrameOffsetX,
                        offsetY: selectFrameOffsetY,
                        selectedOption: $selectedOption,
                        show: $showOptionList
                    )
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
