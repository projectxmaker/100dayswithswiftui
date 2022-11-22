//
//  DiceViewModel.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

class DiceListViewModel: ObservableObject {
    @Published var dices = [Dice]()
    @Published var hello = UUID()
    
    func generateDices(numberOfDices: Int) {
        dices.removeAll()
        for _ in 0..<Int(numberOfDices) {
            let newDice = Dice()
            dices.append(newDice)
            hello = newDice.id
        }
        print(dices)
    }
    
//    func runRandom() {
//        var counter = 0
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            counter += 1
//            self.hello = UUID()
//            print(">>> \(self.hello)")
//            if counter == 5 {
//                timer.invalidate()
//            }
//        }
//    }
    
    private var rollingLogManager = RollingLogManager.shared
//    
//    private var isShowingSideValue = true
//    private var visibleValue: Int = 1
//    private var numberOfSides: Int = 4
//    
//    var showingSideValue: Bool {
//        return isShowingSideValue
//    }
//    
//    var currenVisibleValue: Int {
//        return visibleValue
//    }
//    
    
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
//
//    func moveToNextSideValue(postAction: ((Bool, Int) -> Void)? = nil) {
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(visibleValue)")
//        if isShowingSideValue {
//            isShowingSideValue.toggle()
//        } else {
//            isShowingSideValue.toggle()
//            increaseSideValue()
//        }
//
//        if let postAction = postAction {
//            postAction(isShowingSideValue, visibleValue)
//        }
//    }
//    
//    private func increaseSideValue() {
//        print("start increasement \(visibleValue) vs \(numberOfSides)")
//        
//        if visibleValue < numberOfSides {
//            visibleValue += 1
//        } else {
//            visibleValue = 1
//        }
//        
//        print("finished increased \(visibleValue)")
//    }
    
}
