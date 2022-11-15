//
//  DiceView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct DiceView: View {
    
    
    @State private var visibleSideValue = 1
    @State private var sideValues = [Int]()
    
    var numberOfSides: Int = 4
    var sideValueColor = Color.black
    var backgroundColor = Color.white
    var shadowColor = Color.gray
    var width: CGFloat = 80
    var height: CGFloat = 130
    var arrowLeftColor = Color.gray
    var arrowRightColor = Color.gray

    
    @State private var isShowingSideValue = true
    @State private var timer = Timer()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(arrowLeftColor)
                
                if isShowingSideValue {
                    Text("\(visibleSideValue)")
                        .font(.largeTitle.bold())
                        .foregroundColor(sideValueColor)
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
                }
                
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundColor(arrowRightColor)
            }
        }
        .frame(width: width, height: height)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: shadowColor, radius: 10, x: 1, y: 1)
        .task {
            sideValues = Array(1...numberOfSides)
            
            Timer.scheduledTimer(withTimeInterval: 0.34, repeats: true) { timer in
                withAnimation(.easeInOut(duration: 0.3)) {
                    if isShowingSideValue {
                        isShowingSideValue.toggle()
                    } else {
                        if visibleSideValue < numberOfSides {
                            visibleSideValue += 1
                        } else {
                            visibleSideValue = 1
                        }

                        isShowingSideValue.toggle()
                    }
                }

            }
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}
