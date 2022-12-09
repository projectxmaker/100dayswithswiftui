//
//  ContentViewModel.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    // MARK: - Published Variables
    @Published var showFlagAnimations = [Bool](repeating: false, count: 3)
    @Published var showingFinalAlertScore = false
    @Published var showingScore = false
    
    // MARK: Public Variables
    var flagsNotChosen = [Bool](repeating: false, count: 3)
    var scoreTitle = ""
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    var correctAnswer = Int.random(in: 0...2)
    var score = 0
    var alertOfFlagTappedMessage: String = ""
    
    // MARK: - Private Variables
    private var roundCounter = 0
    private let limitedNumberOfRounds = 8
    
    // MARK: - Functions
    func flagTapped(_ number: Int) {
        changeUntappedFlagOpacity(tappedFlagIndex: number)
        showFlagAnimations[number].toggle()
        
        var messages = [String]()
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            messages.append("That’s the flag of \(countries[number])")
            score -= 1
        }

        messages.append("Your score is \(score)")
        alertOfFlagTappedMessage = messages.joined(separator: "\n")

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
