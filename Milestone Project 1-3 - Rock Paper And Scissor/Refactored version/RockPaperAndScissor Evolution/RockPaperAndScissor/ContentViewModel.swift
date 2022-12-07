//
//  ContentViewModel.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    var items = ContentView.keys.items
    var botChoice: String = ContentView.generateBotChoice()
    var resultStatus = ContentView.generateResult()
    var score: Int = 0
    var round: Int = 1
    
    @Published var showAlert: Bool = false
    @Published var deactivateButtons = false

    func handleButtonTapped(tappedItem: String) {
        deactivateButtons = true
        
        evaluateUserChoice(tappedItem) {
            if self.isGameOver() {
                self.showAlert = true
            } else {
                self.round += 1
                self.setupDefaultValuesForNewRound()
            }
            
            self.deactivateButtons = false
        }
    }
    
    func isGameOver() -> Bool {
        return round + 1 > ContentView.keys.limitedRounds
    }
    
    func evaluateUserChoice(_ userChoice: String, execute: @escaping () -> Void) {
        let items = ContentView.keys.items
        
        guard
            let indexOfUserChoice = items.firstIndex(of: userChoice),
            let indexOfBotChoice = items.firstIndex(of: botChoice)
        else {
            return
        }
        
        var result = false
        switch resultStatus {
        case .playerWin:
            if indexOfBotChoice + 1 > 2 {
                if indexOfUserChoice == 0 {
                    result = true
                }
            } else {
                if indexOfUserChoice == indexOfBotChoice + 1 {
                    result = true
                }
            }
        case .playerLose:
            if indexOfBotChoice - 1 < 0 {
                if indexOfUserChoice == 2 {
                    result = true
                }
            } else {
                if indexOfUserChoice == indexOfBotChoice - 1 {
                    result = true
                }
            }
        case .playerDraw:
            if indexOfBotChoice == indexOfUserChoice {
                result = true
            }
        }
        
        showCorrespondingEmotionOnItem(matchingResult: result, userChoiceIndex: indexOfUserChoice, execute: execute)
    }
    
    func showCorrespondingEmotionOnItem(matchingResult: Bool, userChoiceIndex: Int, execute: @escaping () -> Void) {
        var emotions = ContentView.keys.emotionForWrongAnswer
        if matchingResult {
            emotions = ContentView.keys.emotionForCorrectAnswer
        }

        let shuffedEmotions = emotions.shuffled()
        let selectedEmotion = shuffedEmotions[0]
        let currentItem = items[userChoiceIndex]
        
        items[userChoiceIndex] = selectedEmotion
        
        DispatchQueue.main.asyncAfter(deadline: .now() + ContentView.keys.emotionDisplayDelay) {
            self.items[userChoiceIndex] = currentItem
            
            if matchingResult {
                self.score += 1
            } else {
                self.score -= 1
            }
            
            execute()
        }
    }
    
    func setupDefaultValuesForNewRound() {
        botChoice = ContentView.generateBotChoice(currentChoice: botChoice)
        resultStatus = ContentView.generateResult()
    }
    
    func restartGame() {
        score = 0
        round = 1
        setupDefaultValuesForNewRound()
    }
}
