//
//  DiceView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct DiceView: View {
    @Binding var switcher: Bool
    @Binding var visibleValue: Int
    
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
    @State private var timer: Timer?
    
    private func moveToNextSideValue() {
        if isShowingSideValue {
            isShowingSideValue.toggle()
        } else {
            increaseSideValue()

            isShowingSideValue.toggle()
        }
    }
    
    private func increaseSideValue() {
        if visibleValue < numberOfSides {
            visibleValue += 1
        } else {
            visibleValue = 1
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(arrowLeftColor)
                
                if isShowingSideValue {
                    Text("\(visibleValue)")
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
        .onChange(of: switcher, perform: { newValue in
            if switcher {
                timer = Timer.scheduledTimer(withTimeInterval: 0.34, repeats: true) { timer in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        moveToNextSideValue()
                    }

                }
            } else {
                timer?.invalidate()
                if !isShowingSideValue {
                    increaseSideValue()
                    isShowingSideValue.toggle()
                }
            }
        })
        .task {
            sideValues = Array(1...numberOfSides)
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(switcher: .constant(false), visibleValue: .constant(1))
    }
}
