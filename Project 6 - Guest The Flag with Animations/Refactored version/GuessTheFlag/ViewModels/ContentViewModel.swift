//
//  ContentViewModel.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    // MARK: - Published Variables
    @Published var showFlagAnimations = [Bool](repeating: false, count: 3)
    @Published var showingFinalAlertScore = false
    @Published var showingScore = false
    
    // MARK: Public Variables
    var flagsNotChosen = [Bool](repeating: false, count: 3)
    var scoreTitle: LocalizedStringKey = ""
    var countries = [
        Country(name: "Estonia", flag: "Estonia"),
        Country(name: "France", flag: "France"),
        Country(name: "Germany", flag: "Germany"),
        Country(name: "Ireland", flag: "Ireland"),
        Country(name: "Italy", flag: "Italy"),
        Country(name: "Nigeria", flag: "Nigeria"),
        Country(name: "Poland", flag: "Poland"),
        Country(name: "Russia", flag: "Russia"),
        Country(name: "Spain", flag: "Spain"),
        Country(name: "UK", flag: "UK")
    ].shuffled()
    var correctAnswer = Int.random(in: 0...2)
    var score = 0
    var alertOfFlagTappedMessage: LocalizedStringKey = ""
    
    // MARK: - Private Variables
    private var roundCounter = 0
    private let limitedNumberOfRounds = 8
    
    // MARK: - Functions
    func flagTapped(_ number: Int) {
        changeUntappedFlagOpacity(tappedFlagIndex: number)
        showFlagAnimations[number].toggle()
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
            alertOfFlagTappedMessage = "That’s the flag of \(countries[number].flag).\nYour score is \(score)"
        }
        
        showingScore = true

        roundCounter += 1
    }
    
    func changeUntappedFlagOpacity(tappedFlagIndex: Int) {
        let tmpChangeFlagOpacities = flagsNotChosen
        for (index, _) in tmpChangeFlagOpacities.enumerated() {
            var changeOpacity = false
            if index != tappedFlagIndex {
                changeOpacity = true
            }

            flagsNotChosen[index] = changeOpacity
        }
    }
    
    func displayFinalAlert() {
        if isGameOver() {
            showingFinalAlertScore = true
        }
    }
    
    func restartGame() {
        roundCounter = 0
        score = 0
        
        askQuestion()
    }
    
    func askQuestion() {
        guard !isGameOver() else {
            displayFinalAlert()
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagsNotChosen = [Bool](repeating: false, count: 3)
    }
    
    func isGameOver() -> Bool {
        roundCounter == limitedNumberOfRounds
    }
}
