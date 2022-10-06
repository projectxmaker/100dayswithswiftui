//
//  MGSelectionItem.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/6/22.
//

import Foundation
import SwiftUI

public struct MGSelectionItem: View {
    var itemIndex: Int
    //@Binding var showMenuOfMultiplicationTableSelection: Bool
    var multiplicationTable: Int
    var settingsMultiplicationTableHoveredItem: Int
    
    public var body: some View {
        //Text("\(itemIndex)")
        Text("\(itemIndex)")
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 10))
            .font(.system(size: multiplicationTable == itemIndex || settingsMultiplicationTableHoveredItem == itemIndex ? 30 : 18, weight: multiplicationTable == itemIndex ? .bold : .regular))
            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
//            .onTapGesture {
//                withAnimation {
//                    multiplicationTable = itemIndex
//                    showMenuOfMultiplicationTableSelection.toggle()
//                }
//            }
    }
}
