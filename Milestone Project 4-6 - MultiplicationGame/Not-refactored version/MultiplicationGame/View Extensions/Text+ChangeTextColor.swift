//
//  Text+ChangeTextColor.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/10/22.
//

import Foundation
import SwiftUI

struct MGTextColor: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .foregroundColor(color)
        } else {
            content
                .foregroundColor(.white)
                .colorMultiply(color)
        }
    }
}

extension View {
    func changeTextColor(_ color: Color) -> some View {
        modifier(MGTextColor(color: color))
    }
}
