//
//  Dice.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/21/22.
//

import Foundation

class Dice: Identifiable, ObservableObject {
    struct RollingTime {
        let timerInterval: Double
        let animationDuration: Double
    }
    
    var id = UUID()

    @Published var visibleValue: Int = 1
    @Published var isShowingValue: Bool = true
    
    @Published var runPreActionForSingleTapOnSwitcher = false
    @Published var runWhileRollingForSingleTapSwitcher = false
    @Published var runPostActionForSingleTapOnSwitcher = false
    var isSwitcherDisabled = false
    var isPressingSwitcher = false
    var makeVisibleValueSmaller = false
    
    var currentAnimationDurationOfShowingValue: Double = 0
    private var numberOfSides: Int = 4
    let rollingSlowest = 1.34
    let rollingFastest = 0.08
    let rollingStepChangeRate = 0.15
    let rollingTimerDelay = 0.045
    let fastRollingStep = 0.5
    
    private var longPressCounter: Double = 0
    private var longPressTimer: Timer?
    let longPressMinimumDuration: Double = 1
    let longPressTimerTimeInterval: Double = 0.5
    @Published var doingLongPressingOnSwitcher = false
    
    static let sample = Dice()

    private func moveToNextValue() {
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(visibleValue)")
        if isShowingValue {
            isShowingValue.toggle()
        } else {
            increaseValue()
            isShowingValue.toggle()
        }
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(visibleValue)")
    }
    
    func increaseValue() {
        if visibleValue < numberOfSides {
            visibleValue += 1
        } else {
            visibleValue = 1
        }
    }
    
    
    // MARK: - Long Press On Switcher
    func startLongPressOnSwitcher() {
        // notify the view that user starts pressing on switcher
        doingLongPressingOnSwitcher.toggle()
        
        // start long press timer
        // reset counter
        longPressCounter = longPressMinimumDuration
        
        // start timer to track how long the user presses on this button
        longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressTimerTimeInterval, repeats: true, block: { timer in
            print("\(timer.timeInterval) .... \(self.longPressTimerTimeInterval)")
            self.longPressCounter += self.longPressTimerTimeInterval
        })
    }
    
    func stopLongPressOnSwitcher() {
        // notify the view that user stops pressing on switcher
        doingLongPressingOnSwitcher.toggle()
        
        // end timer to get how long the user presses on this button
        longPressTimer?.invalidate()
        
        runAfterLongPressOnSwitcher()
    }
    
    // MARK: - Long Press On Switcher
    func runAfterLongPressOnSwitcher() {
        runSingleTapOnDice(fastRollingInSeconds: longPressCounter, doRunPreActionForSingleTapOnSwitcher: false)

//        } postAction: { _, _ in
//            print(">>>>> DICE HERE")
//
//            self.isSwitcherDisabled = false
//            self.makeVisibleValueSmaller.toggle()
//
//            self.runPostActionForSingleTapOnSwitcher.toggle()
//        }
    }
    
    // MARK: - Single Tap On Switcher
    func runSingleTapOnDice(fastRollingInSeconds: Double? = nil, doRunPreActionForSingleTapOnSwitcher: Bool = true) {
        if !isSwitcherDisabled {
            isPressingSwitcher.toggle()
            makeVisibleValueSmaller.toggle()
            
//            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.isPressingSwitcher.toggle()
                self.isSwitcherDisabled = true
//            }
            
            if doRunPreActionForSingleTapOnSwitcher {
                runPreActionForSingleTapOnSwitcher.toggle()
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.roll(fastRollingInSeconds: fastRollingInSeconds) { _, Double in
                    self.runWhileRollingForSingleTapSwitcher.toggle()
                } postAction: { _, _ in
                    print(">>>>> DICE HERE")
                    
                    self.isSwitcherDisabled = false
                    self.makeVisibleValueSmaller.toggle()
                    
                    self.runPostActionForSingleTapOnSwitcher.toggle()
                }
            }
        }
    }
    
    func roll(fastRollingInSeconds: Double? = nil, actionInEveryLoop: ((Bool, Double) -> Void)? = nil, postAction: @escaping (UUID, Int) -> Void) {
        // create loops
        let runLoops = generateLoops(fastRollingInSeconds: fastRollingInSeconds)
        
        var lastInterval: Double = 0
        for eachLoop in runLoops {
            lastInterval = eachLoop.timerInterval + eachLoop.animationDuration

            Timer.scheduledTimer(withTimeInterval: eachLoop.timerInterval, repeats: false) { timer in
                print("go")
                self.currentAnimationDurationOfShowingValue = eachLoop.animationDuration
                self.moveToNextValue()
                
                if let actionInEveryLoop = actionInEveryLoop {
                    actionInEveryLoop(self.isShowingValue, eachLoop.animationDuration)
                }
            }
        }

        // re-enable Switcher
        Timer.scheduledTimer(withTimeInterval: lastInterval, repeats: false) { timer in
            postAction(self.id, self.visibleValue)
//            withAnimation {
//                isSwitcherDisabled = false
//
//                // do postAction
//                postAction()
//            }
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
    

//
//    @Published var counter = 0
//
//    func runTimer() {
//        self.counter = 0
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            self.counter += 1
//            print(">>> \(self.counter)")
//            if self.counter == 50 {
//                timer.invalidate()
//            }
//        }
//    }
}

extension Dice: Equatable {
    static func == (lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
}
