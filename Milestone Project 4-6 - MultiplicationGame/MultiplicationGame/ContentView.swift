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
    @State private var multiplicationTable = 2
    @State private var numberOfRounds = 5
    @State private var settingsToggle = SettingsToggle.off
    @State private var screenType = ScreenType.main
    
    @State private var roundQuestion = ""
    @State private var roundAnswers = [Int]()
    @State private var roundCorrectAnswer = 0
    
    @State private var playerScore = 0
    
    @State private var inPlay = false
    @State private var isEndGame = false
    @State private var finalScore = 0
    
    @State private var playButtonTitle = "Start"
    
    @State private var numberOfGeneratedRightOperands: Int = 0
    
    @State private var playButtonTapped = false
    @State private var roundAnswerButtonAnimations = [Int: Double]()
    @State private var roundIncorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var roundCorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var showScoreForTappingOnCorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var hideCorrectAnswerButtonAnimations = [Int: Bool]()
    
    @State private var inProcessingATapOnAnAnswerButton = false
    
    let limitedTableRange = 12
    let roundRange = [5, 10, 20]
    
    // MARK: - Extra Funcs
    func play() {
        screenType = ScreenType.play
        playButtonTapped.toggle()
        
        if inPlay == false {
            numberOfGeneratedRightOperands = 0
            inPlay = true
            isEndGame = false
            finalScore = 0
            playerScore = 0
        }
        
        if !isGameOver() {
            inProcessingATapOnAnAnswerButton = false
            
            generateQuestion()
            generateAnswers()
            generateAnswerButtonAnimations()
            generateIncorrectAnswerButtonAnimations()
            generateCorrectAnswerButtonAnimations()
            generateHideCorrectAnswerButtonAnimations()
            generateShowScoreForCorrectAnswerButtonAnimations()
            
            numberOfGeneratedRightOperands += 1
        } else {
            gameOver()
        }
    }
    
    func gameOver() {
        screenType = ScreenType.main
        isEndGame = true
        inPlay = false
        finalScore = playerScore
        playButtonTitle = "Restart"
    }
    
    func quitPlayingGame() {
        screenType = ScreenType.main
        inPlay = false
        playButtonTitle = "Start"
    }
    
    func isGameOver() -> Bool {
        numberOfGeneratedRightOperands == numberOfRounds
    }
    
    func generateQuestion() {
        let rightSideOperand = Int.random(in: 1...12)
        roundQuestion = "\(multiplicationTable) x \(rightSideOperand)"
    }
    
    func activateEffectOnIncorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
        guard let incorrectAnswerButtonIndex = roundAnswers.firstIndex(of: roundCorrectAnswer) else { return }
        
        roundIncorrectAnswerButtonAnimations[answerIndex]?.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            roundCorrectAnswerButtonAnimations[incorrectAnswerButtonIndex]?.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                execute()
            }
        }
    }
    
    func activateEffectOnCorrectAnswerButton(answerIndex: Int, execute: @escaping () -> Void) {
        roundCorrectAnswerButtonAnimations[answerIndex]?.toggle()
        
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
    
    func activateHideEffectOnCorrectAnswerButton(answerIndex: Int) {
        hideCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
    func activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: Int) {
        showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
    func handleAnswerButtonTapped(answerIndex: Int) {
        if !inProcessingATapOnAnAnswerButton {
            inProcessingATapOnAnAnswerButton = true
            
            // spin selected answer button
            roundAnswerButtonAnimations[answerIndex] = (roundAnswerButtonAnimations[answerIndex] ?? 0.0) + 360
            
            // increase player score if correct answer is tapped
            if roundAnswers[answerIndex] == roundCorrectAnswer {
                playerScore += 1
                activateEffectOnCorrectAnswerButton(answerIndex: answerIndex, execute: play)
            } else {
                // selected answer is incorrect, make it red
                activateEffectOnIncorrectAnswerButton(answerIndex: answerIndex, execute: play)
            }
        }
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
        
        var arrayInts = Array(1...144)
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
        roundIncorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            roundIncorrectAnswerButtonAnimations[each] = false
        }
    }
    
    func generateCorrectAnswerButtonAnimations() {
        roundCorrectAnswerButtonAnimations.removeAll(keepingCapacity: true)
        for each in 0...3 {
            roundCorrectAnswerButtonAnimations[each] = false
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
    
    

    func switchSettingsPanel() {
        if settingsToggle == SettingsToggle.off {
            settingsToggle = SettingsToggle.on
        } else {
            settingsToggle = SettingsToggle.off
        }
    }
    @State private var animationAmount = 0.0
    func getMainScreen() -> some View {
        ZStack {
            VStack {
                Text("Multiplication Game")
                    .font(.system(size: 30))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    .fontWeight(.bold)
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    .multilineTextAlignment(.center)
                
                if isEndGame {
                    Spacer()
                    
                    Text("GameOver!")
                        .font(.system(size: 70))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                    
                    Text("Final Score: \(finalScore)")
                        .font(.system(size: 50))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        animationAmount += 360
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            play()
                        }
                    }

                } label: {
                    Text(playButtonTitle.uppercased())
                }
                .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                .font(.system(size: 40))
                .fontWeight(.bold)
                .frame(width: 300, height: 100)
                .background(Color(UIColor.hexStringToUIColor(hex: "f99d07")))
                .clipShape(Capsule())
                .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 0))
                
                Spacer()
            }

            VStack {
                if settingsToggle == SettingsToggle.on {
                    ZStack {
                        Color(UIColor.hexStringToUIColor(hex: "05a899"))
                            .opacity(0.8)
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            VStack {
                                Text("SETTINGS")
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .font(.system(size: 25))
                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                    .fontWeight(.bold)
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 8, x: 5, y: 5)
                                
                                HStack {
                                    Text("Multiplication table")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                    
                                    Spacer()
                                    Picker("Multiplication table", selection: $multiplicationTable) {
                                        ForEach(2...limitedTableRange, id: \.self) {
                                            Text("\($0)")
                                                .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                                .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                        }
                                    }
                                    .tint(Color(UIColor.hexStringToUIColor(hex: "ffff00")))

                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                
                                HStack {
                                    Text("Number of rounds")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                    
                                    Spacer()
                                    Picker("Number Of Rounds", selection: $numberOfRounds) {
                                        ForEach(roundRange, id: \.self) {
                                            Text("\($0)")
                                        }
                                    }
                                    .tint(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .fill(
                                            LinearGradient(stops: [
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.21),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.22),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                                            ], startPoint: .top, endPoint: .bottom)
                                         )
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                            )
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    switchSettingsPanel()
                } label: {
                    Text(settingsToggle == SettingsToggle.off ? "Settings" : "Close")
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: settingsToggle == SettingsToggle.off ? "05a899" : "ffff00")))
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                }
            }
        }
    }
    
    func getPlayScreen() -> some View {

        VStack {
            Spacer()
            Spacer()
            
            Text(roundQuestion)
                .font(.system(size: 100))
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 6, x: 0, y: 1)
            Spacer()
            
            VStack(spacing: 20) {
                ForEach(roundAnswers.indices, id: \.self) { answerIndex in
                    Button {
                        withAnimation {
                            handleAnswerButtonTapped(answerIndex: answerIndex)
                        }
                        
                    } label: {
                        Text("\(roundAnswers[answerIndex])")
                    }
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .frame(width: 300, height: 100)
                    .background(Color(UIColor.hexStringToUIColor(hex: ((roundIncorrectAnswerButtonAnimations[answerIndex] ?? false) ? "fe2640" : ((roundCorrectAnswerButtonAnimations[answerIndex] ?? false) ? "35d461" : "f99d07")))))
                    .clipShape(Capsule())
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    .scaleEffect((hideCorrectAnswerButtonAnimations[answerIndex] ?? false) ? CGSize(width: 0, height: 0) : CGSize(width: 1, height: 1))
                    .animation(Animation.easeIn(duration: 0.3), value: hideCorrectAnswerButtonAnimations[answerIndex])
                    .overlay(content: {
                        let flag = showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] ?? false
                        
                        if flag {
                            Text("+ 1 score")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 6, x: 0, y: 1)
                                .scaleEffect((showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] ?? false) ? CGSize(width: 1, height: 1) : CGSize(width: 0, height: 0))
                                .animation(.easeIn(duration: 1), value: showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] ?? false)
                        }
                    })
                    .rotation3DEffect(.degrees(roundAnswerButtonAnimations[answerIndex] ?? 0.0), axis: (x: 1, y: 0, z: 0))
                }
            }
            Spacer()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    quitPlayingGame()
                } label: {
                    Text("Quit")
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "05a899")))
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                }
            }
        }

    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                ZStack {
                    LinearGradient(stops: [
                        Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0),
                        Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.1),
                        Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.7),
                        Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 1)
                    ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    switch screenType {
                    case .main:
                        getMainScreen()
                    case .play:
                        getPlayScreen()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
