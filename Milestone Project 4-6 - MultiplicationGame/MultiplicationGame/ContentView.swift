//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/3/22.
//

import SwiftUI
import UIKit

enum ScreenType {
    case main
    case play
}

enum SettingsToggle {
    case on
    case off
}

struct ContentView: View {
    @State private var screenType = ScreenType.main
    @State private var changeColorOfLargeTitleOnMainScreen = false
    @State private var multiplicationTable = 2
    @State private var numberOfRounds = 5
    @State private var roundAnswers = [Int]()
    @State private var roundCorrectAnswer = 0
    @State private var inPlay = false
    @State private var isEndGame = false
    @State private var finalScore = 0
    @State private var playButtonTitle = "Start"
    
    //let limitedTableRange = 12
    //@State private var settingsToggle = SettingsToggle.off
    
    
    //@State private var roundQuestion = ""

    
    //@State private var playerScore = 0
    

    
    //@State private var numberOfGeneratedRightOperands: Int = 0
    
    //@State private var startButtonSpinDegree: Double = 0
    //@State private var roundAnswerButtonAnimations = [Int: Double]()
    //@State private var incorrectAnswerButtonAnimations = [Int: Bool]()
    //@State private var correctAnswerButtonAnimations = [Int: Bool]()
    //@State private var showScoreForTappingOnCorrectAnswerButtonAnimations = [Int: Bool]()
    //@State private var hideCorrectAnswerButtonAnimations = [Int: Bool]()
    
    //@State private var inProcessingATapOnAnAnswerButton = false
    
    //@State private var showMenuOfNumberOfRoundSelection = false
    //@State private var showMenuOfMultiplicationTableSelection = false
    
    //@State private var settingsButtonSpinDegree: Double = 0
    
    //@State private var quitButtonSpinDegree: Double = 0
    
    //@State private var goNextRound = false
    
    //@State private var startButtonSpotlightAnimationAmount = 1.0
    
    //@State private var answerButtonSpotlightAnimationAmounts = [Int: Double]()
    

    
    //let numberOfRoundRange = [5, 10, 20]
    //let multiplicationTableRange = 2...12
    
    // MARK: - Extra Funcs
//    func play() {
//        withAnimation() {
//            screenType = ScreenType.play
//
//            if inPlay == false {
//                numberOfGeneratedRightOperands = 0
//                inPlay = true
//                isEndGame = false
//                finalScore = 0
//                playerScore = 0
//                //settingsButtonSpinDegree = 0
//                quitButtonSpinDegree = 0
//                goNextRound = false
//            }
//
//            if !isGameOver() {
//                inProcessingATapOnAnAnswerButton = false
//
//                generateQuestion()
//                generateAnswers()
//                generateAnswerButtonAnimations()
//                generateIncorrectAnswerButtonAnimations()
//                generateCorrectAnswerButtonAnimations()
//                generateHideCorrectAnswerButtonAnimations()
//                generateShowScoreForCorrectAnswerButtonAnimations()
//                generateAnswerButtonSpotlightAnimationAmounts()
//
//                numberOfGeneratedRightOperands += 1
//                goNextRound.toggle()
//            } else {
//                gameOver()
//            }
//        }
//    }
//
//    func gameOver() {
//        withAnimation() {
//            screenType = ScreenType.main
//            isEndGame = true
//            inPlay = false
//            finalScore = playerScore
//            playButtonTitle = "Restart"
//        }
//    }
//
//    func quitPlayingGame() {
//        withAnimation() {
//            screenType = ScreenType.main
//            inPlay = false
//            playButtonTitle = "Start"
//        }
//    }
//
//    func isGameOver() -> Bool {
//        numberOfGeneratedRightOperands == numberOfRounds
//    }
//
//    func generateQuestion() {
//        let rightSideOperand = Int.random(in: 1...12)
//        roundQuestion = "\(multiplicationTable) x \(rightSideOperand)"
//    }
    
//    func activateEffectOnIncorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
//        guard let correctAnswerButtonIndex = roundAnswers.firstIndex(of: roundCorrectAnswer) else { return }
//        
//        incorrectAnswerButtonAnimations[answerIndex]?.toggle()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            correctAnswerButtonAnimations[correctAnswerButtonIndex]?.toggle()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: correctAnswerButtonIndex)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    execute()
//                }
//            }
//        }
//    }
    
//    func activateEffectOnCorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
//        correctAnswerButtonAnimations[answerIndex]?.toggle()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            activateHideEffectOnCorrectAnswerButton(answerIndex: answerIndex)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: answerIndex)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                    execute()
//                }
//            }
//        }
//    }
    
//    func activateHideEffectOnCorrectAnswerButton(answerIndex: Int) {
//        hideCorrectAnswerButtonAnimations[answerIndex] = true
//    }
    
//    func activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: Int) {
//        for (index, _) in roundAnswers.enumerated() {
//            if index != correctAnswerIndex {
//                hideCorrectAnswerButtonAnimations[index] = true
//            }
//        }
//    }
    
//    func activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: Int) {
//        showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] = true
//    }
//    
//    func handleAnswerButtonTapped(answerIndex: Int) {
//        if !inProcessingATapOnAnAnswerButton {
//            inProcessingATapOnAnAnswerButton = true
//            
//            // make spotlight answer button
//            answerButtonSpotlightAnimationAmounts[answerIndex] = 2.0
//            
//            // spin selected answer button
//            roundAnswerButtonAnimations[answerIndex] = (roundAnswerButtonAnimations[answerIndex] ?? 0.0) + 360
//            
//            // increase player score if correct answer is tapped
//            if roundAnswers[answerIndex] == roundCorrectAnswer {
//                playerScore += 1
//                activateEffectOnCorrectAnswerButton(answerIndex: answerIndex) {
//                    goNextRound = false
//                    
//                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
//                    runPlayAfter(deadline: .now() + 0.1)
//                }
//            } else {
//                // selected answer is incorrect, make it red
//                activateEffectOnIncorrectAnswerButton(answerIndex: answerIndex) {
//                    goNextRound = false
//                    
//                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
//                    runPlayAfter(deadline: .now() + 0.1)
//                }
//            }
//        }
//    }
    
//    func runPlayAfter(deadline: DispatchTime) {
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
//            play()
//        }
//    }
    
//    func generateAnswers() {
//        var answers = [Int]()
//
//        let questionData = roundQuestion.components(separatedBy: "x")
//
//        guard
//            let leftOperand = Int(questionData[0].trimmingCharacters(in: .whitespaces)),
//            let rightOperand = Int(questionData[1].trimmingCharacters(in: .whitespaces))
//        else {
//            roundAnswers = answers
//            return
//        }
//
//        roundCorrectAnswer = leftOperand * rightOperand
//
//        answers.append(roundCorrectAnswer)
//
//        let endRange = roundCorrectAnswer + 12
//        var startRange = endRange - 24
//        startRange = startRange >= 2 ? startRange : 2
//
//        var arrayInts = Array(startRange...endRange)
//        arrayInts.removeAll { element in
//            element == roundCorrectAnswer
//        }
//
//        let shuffedInts = arrayInts.shuffled()
//        answers += shuffedInts[0...2]
//
//        roundAnswers = answers.shuffled()
//    }
//
//    func generateAnswerButtonAnimations() {
//        roundAnswerButtonAnimations.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            roundAnswerButtonAnimations[each] = 0.0
//        }
//    }
//
//    func generateIncorrectAnswerButtonAnimations() {
//        incorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            incorrectAnswerButtonAnimations[each] = false
//        }
//    }
//
//    func generateCorrectAnswerButtonAnimations() {
//        correctAnswerButtonAnimations.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            correctAnswerButtonAnimations[each] = false
//        }
//    }
//
//    func generateHideCorrectAnswerButtonAnimations() {
//        hideCorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            hideCorrectAnswerButtonAnimations[each] = false
//        }
//    }
//
//    func generateShowScoreForCorrectAnswerButtonAnimations() {
//        showScoreForTappingOnCorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            showScoreForTappingOnCorrectAnswerButtonAnimations[each] = false
//        }
//    }
//
//    func generateAnswerButtonSpotlightAnimationAmounts() {
//        answerButtonSpotlightAnimationAmounts.removeAll(keepingCapacity: true)
//        for each in 0...3 {
//            answerButtonSpotlightAnimationAmounts[each] = 1.0
//        }
//    }

    func getAppContent() -> some View {
        VStack (spacing: 20) {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.17),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.75),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 1)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

                switch screenType {
                case .main:
                    showMainScreen()
                case .play:
                    showPlayScreen()
                }
            }
        }
    }
    
    func showMainScreen() -> some View {
        MainScreen(
            changeColorOfLargeTitleOnMainScreen: $changeColorOfLargeTitleOnMainScreen,
            numberOfRounds: $numberOfRounds,
            playButtonTitle: $playButtonTitle,
            multiplicationTable: $multiplicationTable,
            isEndGame: isEndGame,
            finalScore: finalScore) {
                screenType = ScreenType.play
            }
    }
    
    func runAfterGameIsOver(_ finalScore: Int) {
        isEndGame = true
        self.finalScore = finalScore
        playButtonTitle = "Restart"
        screenType = ScreenType.main
    }
    
    func funAfterQuittingGame() {
        screenType = ScreenType.main
    }
    
    func showPlayScreen() -> some View {
        PlayScreen(
            numberOfRounds: $numberOfRounds,
            multiplicationTable: $multiplicationTable,
            runAfterGameIsOver: runAfterGameIsOver(_:),
            runQuitGame: funAfterQuittingGame)
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                getAppContent()
            }
        } else {
            NavigationView {
                getAppContent()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
