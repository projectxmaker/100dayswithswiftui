//
//  MGStartButton.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGStartButton: View {
    var action: () -> Void
    var label: String
    var fontSize: CGFloat
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: String = "f99d07"
    @Binding var spotlightAnimationAmount: Double
    var spinDegreeWhenButtonTapped: Double

    var body: some View {
        MGButton(action: {
            action()
        }, label: {
            MGButtonText(label: label, fontSize: fontSize, width: width, height: height, backgroundColor: backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .scaleEffect(spotlightAnimationAmount)
                        .opacity(2 - spotlightAnimationAmount)
                        .animation(
                            .easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            , value: spotlightAnimationAmount)
                    
                }
                .onAppear {
                    spotlightAnimationAmount = 2
                }
                .onDisappear {
                    spotlightAnimationAmount = 1.0
                }
        }, spinDegreeWhenButtonTapped: spinDegreeWhenButtonTapped)
    }
}
