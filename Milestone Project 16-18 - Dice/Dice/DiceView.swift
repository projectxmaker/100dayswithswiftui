//
//  DiceView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct DiceView: View {
    @State private var visibleValue: Int = 1
    
    @State private var sideValues = [Int]()
    
    var numberOfSides: Int = 4
    var valueColor = Color.black
    var valueColorWhenDiceIsRolling = Color.black
    var backgroundColor = Color.white
    var shadowColor = Color.white
    var shadowColorIfPressingSwitcher = Color.white
    var shadowColorWhenDiceIsRolling = Color.black
    var width: CGFloat = 80
    var height: CGFloat = 80
    var arrowLeftColor = Color.gray
    var arrowLeftColorWhenDiceIsRolling = Color.black.opacity(0.5)
    var arrowRightColor = Color.gray
    var arrowRightColorWhenDiceIsRolling = Color.black.opacity(0.5)
    var switcherForgroundColorEnabled = Color.black
    var switcherForgroundColorDisabled = Color.gray
    
    @State private var isShowingSideValue = true
    @State private var diceRollTimer: Timer?
    @State private var isSwitcherDisabled = false
    
    @State private var longPressTimer: Timer?
    @State private var longPressCounter: Double = DiceView.longPressMinimumDuration
    static let longPressMinimumDuration: Double = 1
    let longPressTimerTimeInterval: Double = 0.5
    
    let rollingFastest = 0.08
    let rollingSlowest = 1.34
    let rollingTimerDelay = 0.045
    let rollingStepChangeRate = 0.15
    let fastRollingStep = 0.5
    @State private var runLoops = [RollingTime]()
    @State private var isPressingSwitcher = false
    
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
    
    private func generateLoops(fastRollingInSeconds: Double? = nil) -> [RollingTime] {
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
        
        var fastRollingCount: Double = 0
        var fastRollingLimit = fastRollingStep
        
        if let fastRollingInSeconds = fastRollingInSeconds {
            fastRollingLimit = fastRollingInSeconds
        }
        
        while fastRollingCount <= fastRollingLimit {
            // random loop before being reversed
            for _ in 0..<Int.random(in: 0...10) {
                let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: animationDuration)
                rollingLoops.append(rollingLoop)
                
                timerInterval += animationDuration + rollingTimerDelay
                timerInterval = round(timerInterval * 100)/100.0
            }
            
            fastRollingCount += fastRollingStep
        }
        
        let reversedLoops = rollingLoops.reversed()
        
        // reverse
        for eachRolling in reversedLoops {
            let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: eachRolling.animationDuration)
            rollingLoops.append(rollingLoop)
            
            timerInterval += eachRolling.animationDuration + rollingTimerDelay
            timerInterval = round(timerInterval * 100)/100.0
        }

        return rollingLoops
    }
    
    private func rollDice(fastRollingInSeconds: Double? = nil) {
        if !isSwitcherDisabled {
            withAnimation {
                isSwitcherDisabled = true
            }

            // create loops
            runLoops = generateLoops(fastRollingInSeconds: fastRollingInSeconds)
            
            var lastInterval: Double = 0
            for eachLoop in runLoops {
                lastInterval = eachLoop.timerInterval + eachLoop.animationDuration

                Timer.scheduledTimer(withTimeInterval: eachLoop.timerInterval, repeats: false) { timer in
                    withAnimation(.easeInOut(duration: eachLoop.animationDuration)) {
                        moveToNextSideValue()
                    }
                }
            }

            // re-enable Switcher
            Timer.scheduledTimer(withTimeInterval: lastInterval, repeats: false) { timer in
                withAnimation {
                    isSwitcherDisabled = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                if isSwitcherDisabled {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(isSwitcherDisabled ? .subheadline : .largeTitle)
                        .foregroundColor(isSwitcherDisabled ? arrowLeftColorWhenDiceIsRolling : arrowLeftColor)
                        .transition(.move(edge: .leading))
                }

                if isShowingSideValue {
                    Text("\(visibleValue)")
                        .font(isSwitcherDisabled ? .title2.bold() : .largeTitle.bold())
                        .foregroundColor(isSwitcherDisabled ? valueColorWhenDiceIsRolling : valueColor)
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
                }

                if isSwitcherDisabled {
                    Image(systemName: "arrowtriangle.left.fill")
                        .font(isSwitcherDisabled ? .subheadline : .largeTitle)
                        .foregroundColor(isSwitcherDisabled ? arrowRightColorWhenDiceIsRolling : arrowRightColor)
                        .transition(.move(edge: .trailing))
                }
            }
            .frame(width: width, height: height)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: isPressingSwitcher ? shadowColorIfPressingSwitcher : (isSwitcherDisabled ? shadowColorWhenDiceIsRolling : shadowColor), radius: isPressingSwitcher ? 25 : 10, x: 1, y: 1)
            
            Image(systemName: "square.dashed.inset.filled")
                .font(.largeTitle)
                .foregroundColor(isSwitcherDisabled ? switcherForgroundColorDisabled :  switcherForgroundColorEnabled)
                .onTapGesture {
                    if !isSwitcherDisabled {
                        withAnimation(.easeOut(duration: 2)) {
                            isPressingSwitcher.toggle()
                            
                            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                                isPressingSwitcher.toggle()
                            }
                        }
                        
                        rollDice()
                    }
                }
                .gesture(
                    LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged({ value in
                            if !isSwitcherDisabled {
                                if value == .first(true) {
                                    // effect of pressing on switcher
                                    withAnimation {
                                        isPressingSwitcher.toggle()
                                    }
                                    
                                    // start long press timer
                                    // reset counter
                                    longPressCounter = DiceView.longPressMinimumDuration
                                    
                                    // start timer to track how long the user presses on this button
                                    longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressTimerTimeInterval, repeats: true, block: { timer in
                                        longPressCounter += longPressTimerTimeInterval
                                    })
                                }
                            }
                        })
                        .onEnded({ value in
                            if !isSwitcherDisabled {
                                // effect of pressing on switcher
                                withAnimation(.easeOut(duration: 2)) {
                                    isPressingSwitcher.toggle()
                                }
                                
                                // end timer to get how long the user presses on this button
                                longPressTimer?.invalidate()
                                
                                rollDice(fastRollingInSeconds: longPressCounter)
                            }
                        })
                )
        }
        .task {
            sideValues = Array(1...numberOfSides)
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView()
    }
}
