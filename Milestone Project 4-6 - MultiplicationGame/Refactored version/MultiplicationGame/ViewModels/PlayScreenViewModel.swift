//
//  PlayScreenViewModel.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import Foundation

class PlayScreenViewModel: ObservableObject {
    // MARK: - Published variables
    @Published var goNextRound = false
    @Published var numberOfGeneratedRightOperands: Int = 0
    @Published var roundQuestion = ""
    @Published var roundAnswers = [Int]()
    @Published var roundCorrectAnswer = 0
    @Published var inProcessingATapOnAnAnswerButton = false
    @Published var answerButtonSpotlightAnimationAmounts = [Int: Double]()
    @Published var roundAnswerButtonAnimations = [Int: Double]()
    @Published var correctAnswerButtonAnimations = [Int: Bool]()
    @Published var incorrectAnswerButtonAnimations = [Int: Bool]()
    @Published var hideCorrectAnswerButtonAnimations = [Int: Bool]()
    @Published var showScoreForTappingOnCorrectAnswerButtonAnimations = [Int: Bool]()
    @Published var quitButtonSpinDegree: Double = 0
    @Published var roundContentRotationDegree: Double = 0
    @Published var roundContentShowUp = false
    
    // MARK: - Private variables
    private var playerScore = 0
    
    // MARK: - Public variables
    var numberOfRounds: Int
    var multiplicationTable: Int
    
    var runAfterGameIsOver: (_: Int) -> Void
    var runQuitGame: () -> Void
    
    
    
    init(numberOfRounds: Int, multiplicationTable: Int, runAfterGameIsOver: @escaping (_: Int) -> Void, runQuitGame: @escaping () -> Void) {
        self.numberOfRounds = numberOfRounds
        self.multiplicationTable = multiplicationTable
        self.runAfterGameIsOver = runAfterGameIsOver
        self.runQuitGame = runQuitGame
    }
    
    // MARK: - Handle Answer Button Tapped
    func handleAnswerButtonTapped(answerIndex: Int) {
        if !inProcessingATapOnAnAnswerButton {
            inProcessingATapOnAnAnswerButton = true
            
            // make spotlight answer button
            answerButtonSpotlightAnimationAmounts[answerIndex] = 2.0
            
            // spin selected answer button
            roundAnswerButtonAnimations[answerIndex] = (roundAnswerButtonAnimations[answerIndex] ?? 0.0) + 360
            
            // increase player score if correct answer is tapped
            if roundAnswers[answerIndex] == roundCorrectAnswer {
                playerScore += 1
                activateEffectOnCorrectAnswerButton(answerIndex: answerIndex) {
                    self.goNextRound = false
                    self.roundContentShowUp = false
                    self.roundContentRotationDegree = 0
                    
                    self.answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    self.runPlayAfter(deadline: .now() + 0.1)
                }
            } else {
                // selected answer is incorrect, make it red
                activateEffectOnIncorrectAnswerButton(answerIndex: answerIndex) {
                    self.goNextRound = false
                    self.roundContentShowUp = false
                    self.roundContentRotationDegree = 0
                    
                    self.answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    self.runPlayAfter(deadline: .now() + 0.1)
                }
            }
        }
    }
    
    func startRound() {
        // generate data for new round
        if !isGameOver() {
            inProcessingATapOnAnAnswerButton = false
            generateQuestion()
            generateAnswers()
            generateAnswerButtonAnimations()
            generateIncorrectAnswerButtonAnimations()
            generateCorrectAnswerButtonAnimations()
            generateHideCorrectAnswerButtonAnimations()
            generateShowScoreForCorrectAnswerButtonAnimations()
            generateAnswerButtonSpotlightAnimationAmounts()
            
            numberOfGeneratedRightOperands += 1
            
            // start
            goNextRound = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.roundContentShowUp = true
                if self.roundContentRotationDegree == 0 {
                    self.roundContentRotationDegree = 360
                } else {
                    self.roundContentRotationDegree = 0
                }
            }
            
        } else {
            roundContentShowUp = false
            roundContentRotationDegree = 0
            
            goNextRound = false
            
            gameOver { finalScore in
                self.runAfterGameIsOver(finalScore)
            }
        }
    }
    
    func moveToNextRound() {
        startRound()
    }
    
    func quitPlayingGame() {
        runQuitGame()
    }
    
    // MARK: - Extra Funcs
    func isGameOver() -> Bool {
        numberOfGeneratedRightOperands == numberOfRounds
    }
    
    func gameOver(action: @escaping (_: Int) -> Void) {
        action(playerScore)
    }
    
    func generateQuestion() {
        let rightSideOperand = Int.random(in: 1...12)
        roundQuestion = "\(multiplicationTable) x \(rightSideOperand)"
    }
    
    func generateAnswers() {
        var answers = [Int]()

        let questionData = roundQuestion.components(separatedBy: "x")

        guard
            let leftOperand = Int(questionData[0].trimmingCharacters(in: .whitespaces)),
            let rightOperand = Int(questionData[1].trimmingCharacters(in: .whitespaces))
        else {
            roundAnswers = answers
            return
        }

        roundCorrectAnswer = leftOperand * rightOperand

        answers.append(roundCorrectAnswer)

        let endRange = roundCorrectAnswer + 12
        var startRange = endRange - 24
        startRange = startRange >= 2 ? startRange : 2

        var arrayInts = Array(startRange...endRange)
        arrayInts.removeAll { element in
            element == roundCorrectAnswer
        }

        let shuffedInts = arrayInts.shuffled()
        answers += shuffedInts[0...2]

        roundAnswers = answers.shuffled()
    }

    func generateAnswerButtonAnimations() {
        roundAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            roundAnswerButtonAnimations[each] = 0.0
        }
    }

    func generateIncorrectAnswerButtonAnimations() {
        incorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            incorrectAnswerButtonAnimations[each] = false
        }
    }

    func generateCorrectAnswerButtonAnimations() {
        correctAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            correctAnswerButtonAnimations[each] = false
        }
    }

    func generateHideCorrectAnswerButtonAnimations() {
        hideCorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            hideCorrectAnswerButtonAnimations[each] = false
        }
    }

    func generateShowScoreForCorrectAnswerButtonAnimations() {
        showScoreForTappingOnCorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            showScoreForTappingOnCorrectAnswerButtonAnimations[each] = false
        }
    }

    func generateAnswerButtonSpotlightAnimationAmounts() {
        answerButtonSpotlightAnimationAmounts.removeAll(keepingCapacity: true)
        for each in 0...3 {
            answerButtonSpotlightAnimationAmounts[each] = 1.0
        }
    }

    
    func activateEffectOnCorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
        correctAnswerButtonAnimations[answerIndex]?.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.activateHideEffectOnCorrectAnswerButton(answerIndex: answerIndex)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: answerIndex)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    execute()
                }
            }
        }
    }
    
    func activateEffectOnIncorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
        guard let correctAnswerButtonIndex = roundAnswers.firstIndex(of: roundCorrectAnswer) else { return }
        
        incorrectAnswerButtonAnimations[answerIndex]?.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.correctAnswerButtonAnimations[correctAnswerButtonIndex]?.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: correctAnswerButtonIndex)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    execute()
                }
            }
        }
    }
    
    func activateHideEffectOnCorrectAnswerButton(answerIndex: Int) {
        hideCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
    func activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: Int) {
        showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
    func activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: Int) {
        for (index, _) in roundAnswers.enumerated() {
            if index != correctAnswerIndex {
                hideCorrectAnswerButtonAnimations[index] = true
            }
        }
    }
    
    func runPlayAfter(deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.moveToNextRound()
        }
    }
}
