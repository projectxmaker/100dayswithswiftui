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
    private var isShowingValue: Bool = true
    private var numberOfSides: Int = 4
    let rollingSlowest = 1.34
    let rollingFastest = 0.08
    let rollingStepChangeRate = 0.15
    let rollingTimerDelay = 0.045
    let fastRollingStep = 0.5
    
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
    
    func roll(fastRollingInSeconds: Double? = nil, actionInEveryLoop: ((Bool, Double) -> Void)? = nil, postAction: @escaping (UUID, Int) -> Void) {
        // create loops
        let runLoops = generateLoops(fastRollingInSeconds: fastRollingInSeconds)
        
        var lastInterval: Double = 0
        for eachLoop in runLoops {
            lastInterval = eachLoop.timerInterval + eachLoop.animationDuration

            Timer.scheduledTimer(withTimeInterval: eachLoop.timerInterval, repeats: false) { timer in
                print("go")
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
