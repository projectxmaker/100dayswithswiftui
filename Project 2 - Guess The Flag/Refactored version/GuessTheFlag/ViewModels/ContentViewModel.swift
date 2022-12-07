//
//  ContentViewModel.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    // MARK: - Published variabled
    @Published var showingFinalAlertScore = false
    @Published var showingScore = false
    @Published private(set) var scoreTitle = ""
    
    @Published private(set) var countries: [Country] = [
        Country(name: "Estonia", imageName: "Estonia"),
        Country(name: "France", imageName: "France"),
        Country(name: "Germany", imageName: "Germany"),
        Country(name: "Italy", imageName: "Italy"),
        Country(name: "Poland", imageName: "Poland"),
        Country(name: "Russia", imageName: "Russia"),
        Country(name: "Spain", imageName: "Spain"),
        Country(name: "UK", imageName: "UK"),
        Country(name: "US", imageName: "US")
        ].shuffled()
    
    @Published private(set) var correctAnswer = Int.random(in: 0...2)
    
    @Published private(set) var score = 0
    
    // MARK: - Public variable
    var tappedFlagIndex: Int = 0
    
    // MARK: - Private variables
    private var roundCounter = 0
    private let limitedNumberOfRounds = 8
    
    // MARK: - Computed properties
    var correctAnswerTitle: LocalizedStringKey {
        countries[correctAnswer].name
    }
    
    // MARK: - Functions
    
    func getCountryNameByIndex() -> LocalizedStringKey {
        countries[tappedFlagIndex].name
    }
    
    func flagTapped(_ number: Int) {
        tappedFlagIndex = number
        
        if tappedFlagIndex == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }

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
