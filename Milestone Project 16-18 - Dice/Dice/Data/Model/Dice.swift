//
//  Dice.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/21/22.
//

import Foundation
import SwiftUI

class Dice: Identifiable, ObservableObject {
    struct RollingTime {
        let timerInterval: Double
        let animationDuration: Double
    }
    var numberOfPossibilities: Double
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
    
    var groupId: UUID?
    
    private var rollingLogManager = RollingLogManager.shared
    
    static let sample = Dice(numberOfPossibilities: 4)
    
    private var feedback = UIImpactFeedbackGenerator(style: .rigid)

    init(numberOfPossibilities: Double) {
        self.numberOfPossibilities = numberOfPossibilities
    }
    
    private func moveToNextValue() {
        if isShowingValue {
            isShowingValue.toggle()
        } else {
            increaseValue()
            isShowingValue.toggle()
        }
    }
    
    func increaseValue() {
        if visibleValue < Int(numberOfPossibilities) {
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
            self.longPressCounter += self.longPressTimerTimeInterval
        })
    }
    
    func stopLongPressOnSwitcher(groupId: UUID) {
        // set group id
        self.groupId = groupId
        
        // notify the view that user stops pressing on switcher
        doingLongPressingOnSwitcher.toggle()
        
        // end timer to get how long the user presses on this button
        longPressTimer?.invalidate()
        
        runAfterLongPressOnSwitcher()
    }
    
    func runAfterLongPressOnSwitcher() {
        guard let groupId = self.groupId else {
            fatalError("Dice's group id is missing")
        }
        
        runSingleTapOnDice(groupId: groupId, fastRollingInSeconds: longPressCounter, doRunPreActionForSingleTapOnSwitcher: false)
    }
    
    // MARK: - Single Tap On Switcher
    func runSingleTapOnDice(groupId: UUID, fastRollingInSeconds: Double? = nil, doRunPreActionForSingleTapOnSwitcher: Bool = true) {
        if !isSwitcherDisabled {
            // set group id
            self.groupId = groupId
            
            isPressingSwitcher.toggle()
            makeVisibleValueSmaller.toggle()
            
            isPressingSwitcher.toggle()
            isSwitcherDisabled = true
            
            if doRunPreActionForSingleTapOnSwitcher {
                runPreActionForSingleTapOnSwitcher.toggle()
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                self.roll(fastRollingInSeconds: fastRollingInSeconds) { _, Double in
                    self.runWhileRollingForSingleTapSwitcher.toggle()
                } postAction: { _, _ in
                    self.isSwitcherDisabled = false
                    self.makeVisibleValueSmaller.toggle()
                    
                    self.runPostActionForSingleTapOnSwitcher.toggle()
                    
                    self.rollingLogManager.logDice(of: self)
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
                
                // trigger haptic
                self.feedback.impactOccurred()
                
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
}

extension Dice: Equatable {
    static func == (lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
}
