//
//  GameEngine.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct PlayScreen: View {
    @State private var goNextRound = false
    @State private var numberOfGeneratedRightOperands: Int = 0
    @State private var roundQuestion = ""
    @State private var roundAnswers = [Int]()
    @State private var roundCorrectAnswer = 0
    @State private var inProcessingATapOnAnAnswerButton = false
    @State private var answerButtonSpotlightAnimationAmounts = [Int: Double]()
    @State private var roundAnswerButtonAnimations = [Int: Double]()
    @State private var playerScore = 0
    @State private var correctAnswerButtonAnimations = [Int: Bool]()
    @State private var incorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var hideCorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var showScoreForTappingOnCorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var quitButtonSpinDegree: Double = 0
    
    
    @Binding var numberOfRounds: Int
    @Binding var multiplicationTable: Int
    
    @State private var roundContentRotationDegree: Double = 0
    @State private var roundContentShowUp = false
    
    var runAfterGameIsOver: (_: Int) -> Void
    var runQuitGame: () -> Void
    
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
                    goNextRound = false
                    roundContentShowUp = false
                    roundContentRotationDegree = 0
                    
                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    runPlayAfter(deadline: .now() + 0.1)
                }
            } else {
                // selected answer is incorrect, make it red
                activateEffectOnIncorrectAnswerButton(answerIndex: answerIndex) {
                    goNextRound = false
                    roundContentShowUp = false
                    roundContentRotationDegree = 0
                    
                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    runPlayAfter(deadline: .now() + 0.1)
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
                roundContentShowUp = true
                if roundContentRotationDegree == 0 {
                    roundContentRotationDegree = 360
                } else {
                    roundContentRotationDegree = 0
                }
            }
            
        } else {
            roundContentShowUp = false
            roundContentRotationDegree = 0
            
            goNextRound = false
            
            gameOver { finalScore in
                runAfterGameIsOver(finalScore)
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
            activateHideEffectOnCorrectAnswerButton(answerIndex: answerIndex)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: answerIndex)
                
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
            correctAnswerButtonAnimations[correctAnswerButtonIndex]?.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: correctAnswerButtonIndex)
                
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
            moveToNextRound()
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                if goNextRound {
                    VStack {
                        Text("ROUND \(numberOfGeneratedRightOperands)/\(numberOfRounds)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), radius: 10, x: 0, y: 1)
                        
                        Spacer()
                        
                        Text(roundQuestion)
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        
                        
                        Spacer()
                        
                        VStack(spacing: 20) {
                            ForEach(roundAnswers.indices, id: \.self) { answerIndex in
                                MGAnswerButton(
                                    action: {
                                        withAnimation {
                                            handleAnswerButtonTapped(answerIndex: answerIndex)
                                        }
                                        
                                    }, label: "\(roundAnswers[answerIndex])"
                                    , fontSize: 50, width: 300, height: 100
                                    , backgroundColor:  ((incorrectAnswerButtonAnimations[answerIndex] ?? false) ? "fe2640" : ((correctAnswerButtonAnimations[answerIndex] ?? false) ? "35d461" : "f99d07"))
                                    , spotlightAnimationAmount: answerButtonSpotlightAnimationAmounts[answerIndex] ?? 0
                                    , spinDegreeWhenButtonTapped: roundAnswerButtonAnimations[answerIndex] ?? 0.0
                                    , hideAnimation: hideCorrectAnswerButtonAnimations[answerIndex] ?? false
                                    , isCorrectButtonTapped: showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] ?? false
                                )
                            }
                        }
                        Spacer()
                        Spacer()
                    }
                    .scaleEffect(roundContentShowUp ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: roundContentRotationDegree), axis: (x: 0, y: 1, z: 0))
                    .animation(.easeOut(duration: 0.5), value: roundContentRotationDegree)
                }
            }
            .onAppear {
                startRound()
            }
            
            VStack {
                Spacer()
                
                Button {
                    withAnimation {
                        quitButtonSpinDegree += 360
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            quitPlayingGame()
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50, style: .circular)
                            .fill(Material.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "05a899")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    }
                }
                .offset(y: -5)
                .rotation3DEffect(.degrees(quitButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
            }
        }
    }
}
