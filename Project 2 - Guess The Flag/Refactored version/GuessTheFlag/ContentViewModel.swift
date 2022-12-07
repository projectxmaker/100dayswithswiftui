//
//  ContentViewModel.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var showingFinalAlertScore = false
    @Published var showingScore = false
    @Published private(set) var scoreTitle = ""
    
    @Published private(set) var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @Published private(set) var correctAnswer = Int.random(in: 0...2)
    
    @Published private(set) var score = 0
    @Published private(set) var alertOfFlagTappedMessage: String = ""
    
    private var roundCounter = 0
    private let limitedNumberOfRounds = 8
    
    func flagTapped(_ number: Int) {
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
    }
    
    func isGameOver() -> Bool {
        roundCounter == limitedNumberOfRounds
    }
}
