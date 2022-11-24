//
//  DiceViewModel.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation
import SwiftUI

class DiceListViewModel: ObservableObject {
    @Published var dices = [Dice]()
    @Published var numberOfDices: Double = 1
    @Published var numberOfPossibilities: Double = 4
    @Published var isShowingSettings = false
    @Published var isShowingRollingLogView = false
    
    @Published var isPressingOnPowerSwitcher = false
    @Published var isRollingMultipleDicesByPowerSwitcher = false
    
    let maximumDices: Double = 50
    let maximumPossibilities: Double = 100
    
    private var rollingLogManager = RollingLogManager.shared
    private var settingsManager = SettingsManager.shared
    
    init() {
        numberOfDices = settingsManager.settings.numberOfDices
        numberOfPossibilities = settingsManager.settings.numberOfPossibilities
    }
    
    func generateDices() {
        dices.removeAll()
        for orderNumber in 0..<Int(numberOfDices) {
            let newDice = Dice(
                numberOfPossibilities: numberOfPossibilities,
                orderNumber: orderNumber
            )
            dices.append(newDice)
        }

        // save new changes of settings
        settingsManager.settings.numberOfPossibilities = numberOfPossibilities
        settingsManager.settings.numberOfDices = numberOfDices
        settingsManager.save()
    }
    
    func checkIfAllDicesFinishedRolling(ofGroupId: UUID) {
        // check if all dices finished rolling
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let rollingDices = self.dices.filter { dice in
                dice.groupId == ofGroupId
            }
            
            // when there's non dice w/ specified groupId, it measn all dices finished rolling
            if rollingDices.isEmpty {
                self.isRollingMultipleDicesByPowerSwitcher.toggle()
                timer.invalidate()
            }
        }
    }
    
    // MARK: - UI
    var singleTapOnSwitcher: some Gesture {
        TapGesture()
            .onEnded { _ in
                if !self.isRollingMultipleDicesByPowerSwitcher {
                    self.isPressingOnPowerSwitcher.toggle()
                    
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        self.isPressingOnPowerSwitcher.toggle()
                    }
                    
                    // now all dices are rolling
                    self.isRollingMultipleDicesByPowerSwitcher.toggle()
                    
                    let newId = self.rollingLogManager.generateNewGroup(
                        numberOfDices: self.numberOfDices,
                        numberOfPossibilities: self.numberOfPossibilities
                    )
                    
                    for eachDice in self.dices {
                        eachDice.runSingleTapOnDice(groupId: newId)
                    }
                    
                    // check if all dices finished rolling
                    self.checkIfAllDicesFinishedRolling(ofGroupId: newId)
                }
            }
    }
    
    var longPressOnSwitcher: some Gesture {
        LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged({ value in
                if !self.isRollingMultipleDicesByPowerSwitcher {
                    if value == .first(true) {
                        self.isPressingOnPowerSwitcher.toggle()
                        
                        for eachDice in self.dices {
                            eachDice.startLongPressOnSwitcher()
                        }
                    }
                }
            })
            .onEnded({ value in
                self.isPressingOnPowerSwitcher.toggle()
                
                // now all dices are rolling
                self.isRollingMultipleDicesByPowerSwitcher.toggle()
                
                let newId = self.rollingLogManager.generateNewGroup(
                    numberOfDices: self.numberOfDices,
                    numberOfPossibilities: self.numberOfPossibilities
                )
                
                for eachDice in self.dices {
                    eachDice.stopLongPressOnSwitcher(groupId: newId)
                }
                
                // check if all dices finished rolling
                self.checkIfAllDicesFinishedRolling(ofGroupId: newId)
            })
    }
}
