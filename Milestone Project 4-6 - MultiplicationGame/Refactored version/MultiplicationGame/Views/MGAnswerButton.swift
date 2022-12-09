//
//  MGAnswerButton.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGAnswerButton: View {
    var action: () -> Void
    var label: String
    var fontSize: CGFloat
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: String = "f99d07"
    var spotlightAnimationAmount: Double
    var spinDegreeWhenButtonTapped: Double
    var hideAnimation: Bool
    var isCorrectButtonTapped: Bool

    var body: some View {
        MGButton(action: {
            action()
        }, label: {
            MGButtonText(label: label, fontSize: fontSize, width: width, height: height, backgroundColor: backgroundColor)
                .overlay {
                    if spotlightAnimationAmount > 0 {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .scaleEffect(spotlightAnimationAmount)
                            .opacity(2 - (spotlightAnimationAmount))
                            .animation(
                                .easeOut(duration: 1)
                                , value: spotlightAnimationAmount
                            )
                    }
                }
        }, spinDegreeWhenButtonTapped: spinDegreeWhenButtonTapped)
        .scaleEffect(hideAnimation ? CGSize(width: 0, height: 0) : CGSize(width: 1, height: 1))
        .animation(Animation.easeIn(duration: 0.3), value: hideAnimation)
        .overlay(content: {
            if isCorrectButtonTapped {
                Text("+ 1 score")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 6, x: 0, y: 1)
                    .scaleEffect(isCorrectButtonTapped ? CGSize(width: 1, height: 1) : CGSize(width: 0, height: 0))
                    .animation(.easeIn(duration: 1), value: isCorrectButtonTapped)
            }
        })
    }
}

struct MGAnswerButton_Preview: PreviewProvider {
    static var previews: some View {
        MGAnswerButton(
            action: {
                print("do nothing")
            },
            label: "Button",
            fontSize: 18,
            width: 100,
            height: 44,
            spotlightAnimationAmount: 1,
            spinDegreeWhenButtonTapped: 360,
            hideAnimation: false,
            isCorrectButtonTapped: false
        )
    }
}
