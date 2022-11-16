//
//  DiceView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct DiceView: View {
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
    var switcherForgroundColor = Color.gray
    
    @State private var switcher: Bool = false
    @State private var isShowingSideValue = true
    @State private var diceRollTimer: Timer?
    
    @State private var longPressTimer: Timer?
    @State private var longPressCounter: Double = DiceView.longPressMinimumDuration
    static let longPressMinimumDuration: Double = 1
    let longPressTimerTimeInterval: Double = 0.5
    
    let rollingFastest = 0.08
    let rollingSlowest = 1.34
    let rollingTimerDelay = 0.045
    let rollingStepChangeRate = 0.15
    @State private var runLoops = [RollingTime]()
    
    struct RollingTime {
        let timerInterval: Double
        let animationDuration: Double
    }
    
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
    
    private func generateLoops(_ numOfLoops: Int) -> [RollingTime] {
        var rollingLoops = [RollingTime]()

        var loopCounter: Int = 0
        
        var timerInterval: Double = 0
        var animationDuration: Double = rollingSlowest
        
        while animationDuration >= rollingFastest {
            animationDuration -= loopCounter == 0 ? 0 :  animationDuration * rollingStepChangeRate
            animationDuration = round(animationDuration * 100)/100.0
            
            let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: animationDuration)
            rollingLoops.append(rollingLoop)
            
            timerInterval += animationDuration + rollingTimerDelay
            timerInterval = round(timerInterval * 100)/100.0
            
            loopCounter += 1
        }
        
        let reversedLoops = rollingLoops.reversed()
        
        for eachRolling in reversedLoops {
            let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: eachRolling.animationDuration)
            rollingLoops.append(rollingLoop)
            
            timerInterval += eachRolling.animationDuration + rollingTimerDelay
            timerInterval = round(timerInterval * 100)/100.0
        }

        return rollingLoops
    }
    
    var body: some View {
        VStack(spacing: 15) {
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
            .frame(width: width, height: height)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: shadowColor, radius: 10, x: 1, y: 1)
            
            Image(systemName: "square.dashed.inset.filled")
                .font(.largeTitle)
                .foregroundColor(switcherForgroundColor)
                .onTapGesture {
                    switcher.toggle()
                }
                .gesture(
                    LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged({ value in
                            if value == .first(true) {
                                // start long press timer
                                // reset counter
                                longPressCounter = DiceView.longPressMinimumDuration
                                
                                // start timer to track how long the user presses on this button
                                longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressTimerTimeInterval, repeats: true, block: { timer in
                                    longPressCounter += longPressTimerTimeInterval
                                })
                            }
                        })
                        .onEnded({ value in
                            // end timer to get how long the user presses on this button
                            longPressTimer?.invalidate()
                            
                            switcher.toggle()
                        })
                )

                .onChange(of: switcher, perform: { newValue in
                    if switcher {
                        for eachLoop in runLoops {
                            Timer.scheduledTimer(withTimeInterval: eachLoop.timerInterval, repeats: false) { timer in
                                withAnimation(.easeInOut(duration: eachLoop.animationDuration)) {
                                    moveToNextSideValue()
                                }
                            }
                        }
                    }
                })
        }
        .task {
            sideValues = Array(1...numberOfSides)
            runLoops = generateLoops(10)
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(visibleValue: .constant(1))
    }
}
