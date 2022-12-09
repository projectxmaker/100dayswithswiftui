//
//  MGPicker.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGSelector: View {
    var options: [Int]
    var width: CGFloat
    var height: CGFloat
    var offsetX: CGFloat
    var offsetY: CGFloat
    @Binding var selectedOption: Int
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            VStack {
                ForEach(options, id: \.self) { index in
                    Text("\(index)")
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 10))
                        .font(.system(size: selectedOption == index ? 30 : 18, weight: selectedOption == index ? .bold : .regular))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                        .gesture(
                            TapGesture(count: 1)
                                .onEnded({ _ in
                                    withAnimation {
                                        selectedOption = index
                                        show.toggle()
                                    }
                                })
                        )
                }
            }
            .frame(width: width, height: height, alignment: .trailing)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .fill(
                        LinearGradient(stops: [
                            Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                            Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                            Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                            Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
            )
        }
        .offset(x: offsetX, y: offsetY)
        .transition(.scale)
    }
}
