//
//  MGButton.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGButton<Content: View>: View {
    var action: () -> Void
    var label: () -> Content
    var spinDegreeWhenButtonTapped: Double
    
    var body: some View {
        Button {
            action()
        } label: {
            label()
        }
        .rotation3DEffect(.degrees(spinDegreeWhenButtonTapped), axis: (x: 1, y: 0, z: 0))
        .buttonStyle(PlainButtonStyle())
    }
}

struct MGButton_Preview: PreviewProvider {
    static var previews: some View {
        MGButton(action: {
            print("button is tapped")
        }, label: {
            Text("Tap Me")
        }, spinDegreeWhenButtonTapped: 360)
    }
}
