//
//  MGButton.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGButtonText: View {
    var label: String
    var fontSize: CGFloat
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: String = "f99d07"
    
    var body: some View {
        Text(label.uppercased())
            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
            .font(.system( size: fontSize))
            .fontWeight(.bold)
            .frame(width: width, height: height)
            .background(Color(UIColor.hexStringToUIColor(hex: backgroundColor)))
            .clipShape(Capsule())
            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
    }
}
