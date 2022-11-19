//
//  DiceViewModel.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

class DiceListViewModel: ObservableObject {
    private var diceManager = DiceManager.shared
    private var rollingLogManager = RollingLogManager.shared
    
    func saveLog(dices: Int, posibilities: Int, result: String, sumOfResult: Int, highestResult: Int, lowestResult: Int) {
        let rollingLog = RollingLog(
            dices: dices,
            posibilities: posibilities,
            result: result,
            sumOfResult: sumOfResult,
            highestResult: highestResult,
            lowestResult: lowestResult
        )
        
        rollingLogManager.insertLog(rollingLog)
    }
    
}
