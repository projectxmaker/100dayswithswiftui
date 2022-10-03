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
    case result
}

enum SettingsToggle {
    case on
    case off
}

struct ContentView: View {
    @State private var multiplicationTable = 2
    @State private var numberOfRounds = 5
    @State private var settingsToggle = SettingsToggle.off
    @State private var screenType = ScreenType.result
    
    @State private var rightSideOperands = [Int]()
    
    @State private var roundQuestion = ""
    @State private var roundAnswers = [Int]()
    @State private var roundCorrectAnswer = 0
    
    @State private var playerScore = 0
    
    @State private var inPlay = false
    @State private var isEndGame = false
    @State private var finalScore = 0
    
    let limitedTableRange = 12
    let roundRange = [5, 10, 20]
    
    // MARK: - Extra Funcs
    func play() {
       screenType = ScreenType.play
        
        if inPlay == false {
            generateRightSideOperands()
            inPlay = true
        }
        
        if !isGameOver() {
            if let selectedRghtSideOperand = rightSideOperands.first {
                roundQuestion = generateQuestion(rightSideOperand: selectedRghtSideOperand)
                roundAnswers = generateAnswers()
                
                rightSideOperands.remove(at: 0)
            }
        } else {
            quitPlayingGame()
        }
    }
    
    func quitPlayingGame() {
        screenType = ScreenType.main
        isEndGame = true
        inPlay = false
        finalScore = playerScore
        playerScore = 0
        rightSideOperands.removeAll(keepingCapacity: true)
    }
    
    func isGameOver() -> Bool {
        return rightSideOperands.isEmpty
    }
    
    func generateQuestion(rightSideOperand: Int) -> String {
        return "\(multiplicationTable) x \(rightSideOperand)"
    }
    
    func handleAnswerButtonTapped(buttonValue: Int) {
        if buttonValue == roundCorrectAnswer {
            playerScore += 1
        }
        
        // play next round
        play()
    }
    
    func generateAnswers() -> [Int] {
        var answers = [Int]()
        
        let questionData = roundQuestion.components(separatedBy: "x")
        
        guard
            let leftOperand = Int(questionData[0].trimmingCharacters(in: .whitespaces)),
            let rightOperand = Int(questionData[1].trimmingCharacters(in: .whitespaces))
        else {
            return answers
        }
        
        roundCorrectAnswer = leftOperand * rightOperand
        
        answers.append(roundCorrectAnswer)
        
        for _ in 0...2 {
            answers.append(Int.random(in: 1...144))
        }
        
        return answers.shuffled()
    }

    func generateRightSideOperands() {
        var operandValuesLeft = numberOfRounds
        repeat {
            var toBeGeneratedValues = limitedTableRange
            if operandValuesLeft < limitedTableRange {
                toBeGeneratedValues = operandValuesLeft
            }
            
            rightSideOperands += Array(1...toBeGeneratedValues)
            
            operandValuesLeft -= limitedTableRange
        } while (operandValuesLeft > 0)
        
        rightSideOperands.shuffle()
    }
    
    func switchSettingsPanel() {
        if settingsToggle == SettingsToggle.off {
            settingsToggle = SettingsToggle.on
        } else {
            settingsToggle = SettingsToggle.off
        }
    }
    
    func getMainScreen() -> some View {
        VStack (spacing: 20) {
            ZStack {
                VStack {
                    if isEndGame {
                        Spacer()
                        
                        Text("GameOver!")
                            .font(.system(size: 70))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "37B6F6")))
                        
                        Text("Final Score: \(finalScore)")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "37B6F6")))
                        
                    } else {
                        Spacer()
                    }
                    
                    Button {
                        play()
                    } label: {
                        Text("PLAY")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .frame(width: 200, height: 100)
                    .background(.blue)
                    .clipShape(Capsule())
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    if settingsToggle == SettingsToggle.on {
                        Form {
                            Section("Settings") {
                                Picker("Multiplication Table", selection: $multiplicationTable) {
                                    ForEach(2...limitedTableRange, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                Picker("Number Of Rounds", selection: $numberOfRounds) {
                                    ForEach(roundRange, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                            }
                        }
                        .frame(height: settingsToggle == SettingsToggle.off ? 0 : 180)
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        switchSettingsPanel()
                    } label: {
                        Text(settingsToggle == SettingsToggle.off ? "Settings" : "Close")
                            .foregroundColor(.blue)
                    }
                }
            }
        }

        .ignoresSafeArea()
    }
    
    func getPlayScreen() -> some View {
        VStack (spacing: 20) {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "37B6F6")), location: 0),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "37B6F6")), location: 0.2),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f9e104")), location: 0.4),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                ], startPoint: .top, endPoint: .bottom)
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    Text(roundQuestion)
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        ForEach(roundAnswers, id: \.self) { answerValue in
                            Button {
                                handleAnswerButtonTapped(buttonValue: answerValue)
                            } label: {
                                Text("\(answerValue)")
                            }
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: 300, height: 100)
                            .background(Color(UIColor.hexStringToUIColor(hex: "37B6F6")))
                            .clipShape(Capsule())
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
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var body: some View {
        NavigationView {
            switch screenType {
            case .main:
                getMainScreen()
            case .play:
                getPlayScreen()
            case .result:
                getMainScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
