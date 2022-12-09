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

struct MGSelector_Preview: PreviewProvider {
    struct SampleView: View {
        var options = 2...12
        var width: CGFloat = 100
        var height: CGFloat = 380
        var offsetX: CGFloat = -20
        var offsetY: CGFloat = -210
        
        @State var selectedOption: Int = 5
        @State var show: Bool = false
        
        var body: some View {
            MGSelector(
                options: Array(options),
                width: width,
                height: height,
                offsetX: offsetX,
                offsetY: offsetY,
                selectedOption: $selectedOption,
                show: $show
            )
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
