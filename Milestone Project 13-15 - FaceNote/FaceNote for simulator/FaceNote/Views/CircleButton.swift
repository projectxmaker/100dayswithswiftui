//
//  BlueCircleButton.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/3/22.
//

import SwiftUI

struct CircleButton: View {
    var imageSystemName: String
    var backgroundColor = Color.blue.opacity(0.75)
    var foregroundColor = Color.white
    var font = Font.title.weight(.bold)
    var shadownColor = Color.gray
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: imageSystemName)
                .padding()
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .font(font)
                .clipShape(Circle())
                .padding(.trailing)
                .shadow(color: .white, radius: 10, x: 1, y: 1)
        }
    }
}
