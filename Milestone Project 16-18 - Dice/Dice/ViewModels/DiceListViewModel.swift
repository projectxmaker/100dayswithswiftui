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
        for _ in 0..<Int(numberOfDices) {
            let newDice = Dice(numberOfPossibilities: numberOfPossibilities)
            dices.append(newDice)
        }
        
        // save new changes of settings
        settingsManager.settings.numberOfPossibilities = numberOfPossibilities
        settingsManager.settings.numberOfDices = numberOfDices
        settingsManager.save()
    }
    
    // MARK: - UI
    var singleTapOnSwitcher: some Gesture {
        TapGesture()
            .onEnded { _ in
                let newId = self.rollingLogManager.generateNewGroup(
                    numberOfDices: self.numberOfDices,
                    numberOfPossibilities: self.numberOfPossibilities
                )
                
                for eachDice in self.dices {
                    eachDice.runSingleTapOnDice(groupId: newId)
                }
            }
    }
    
    var longPressOnSwitcher: some Gesture {
        LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged({ value in
                if value == .first(true) {
                    for eachDice in self.dices {
                        eachDice.startLongPressOnSwitcher()
                    }
                }
            })
            .onEnded({ value in
                let newId = self.rollingLogManager.generateNewGroup(
                    numberOfDices: self.numberOfDices,
                    numberOfPossibilities: self.numberOfPossibilities
                )
                
                for eachDice in self.dices {
                    eachDice.stopLongPressOnSwitcher(groupId: newId)
                }
            })
    }
}
