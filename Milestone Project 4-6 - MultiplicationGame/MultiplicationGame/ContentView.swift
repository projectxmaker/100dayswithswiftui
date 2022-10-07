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
    
    @State private var startButtonSpinDegree: Double = 0
    @State private var roundAnswerButtonAnimations = [Int: Double]()
    @State private var incorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var correctAnswerButtonAnimations = [Int: Bool]()
    @State private var showScoreForTappingOnCorrectAnswerButtonAnimations = [Int: Bool]()
    @State private var hideCorrectAnswerButtonAnimations = [Int: Bool]()
    
    @State private var inProcessingATapOnAnAnswerButton = false
    
    @State private var showMenuOfNumberOfRoundSelection = false
    @State private var showMenuOfMultiplicationTableSelection = false
    
    @State private var settingsButtonSpinDegree: Double = 0
    @State private var settingsMultiplicationTableHoveredItem = 0
    @State private var settingsRoundHoveredItem = 0
    
    @State private var quitButtonSpinDegree: Double = 0
    
    @State private var goNextRound = false
    
    @State private var startButtonSpotlightAnimationAmount = 1.0
    
    @State private var answerButtonSpotlightAnimationAmounts = [Int: Double]()
    @State private var changeColorOfLargeTitleOnMainScreen = false

    let limitedTableRange = 12
    let numberOfRoundRange = [5, 10, 20]
    let multiplicationTableRange = 2...12
    
    // MARK: - Extra Funcs
    func play() {
        withAnimation() {
            screenType = ScreenType.play
            
            if inPlay == false {
                numberOfGeneratedRightOperands = 0
                inPlay = true
                isEndGame = false
                finalScore = 0
                playerScore = 0
                settingsButtonSpinDegree = 0
                quitButtonSpinDegree = 0
                goNextRound = false
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
                generateAnswerButtonSpotlightAnimationAmounts()
                
                numberOfGeneratedRightOperands += 1
                goNextRound.toggle()
            } else {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        withAnimation() {
            screenType = ScreenType.main
            isEndGame = true
            inPlay = false
            finalScore = playerScore
            playButtonTitle = "Restart"
        }
    }
    
    func quitPlayingGame() {
        withAnimation() {
            screenType = ScreenType.main
            inPlay = false
            playButtonTitle = "Start"
        }
    }
    
    func isGameOver() -> Bool {
        numberOfGeneratedRightOperands == numberOfRounds
    }
    
    func generateQuestion() {
        let rightSideOperand = Int.random(in: 1...12)
        roundQuestion = "\(multiplicationTable) x \(rightSideOperand)"
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
    
    func activateHideEffectOnCorrectAnswerButton(answerIndex: Int) {
        hideCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
    func activateHideEffectOnIncorrectAnswerButton(correctAnswerIndex: Int) {
        for (index, _) in roundAnswers.enumerated() {
            if index != correctAnswerIndex {
                hideCorrectAnswerButtonAnimations[index] = true
            }
        }
    }
    
    func activateShowScoreForTappingOnCorrectAnswerButton(answerIndex: Int) {
        showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] = true
    }
    
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
                    
                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    runPlayAfter(deadline: .now() + 0.1)
                }
            } else {
                // selected answer is incorrect, make it red
                activateEffectOnIncorrectAnswerButton(answerIndex: answerIndex) {
                    goNextRound = false
                    
                    answerButtonSpotlightAnimationAmounts[answerIndex] = 1.0
                    runPlayAfter(deadline: .now() + 0.1)
                }
            }
        }
    }
    
    func runPlayAfter(deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            play()
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
    
    func switchSettingsPanel() {
        settingsButtonSpinDegree += 360
        
        if settingsToggle == SettingsToggle.off {
            settingsToggle = SettingsToggle.on
        } else {
            settingsToggle = SettingsToggle.off
            showMenuOfNumberOfRoundSelection = false
            showMenuOfMultiplicationTableSelection = false
        }
    }
    
    func getMainScreen() -> some View {
        ZStack {
            VStack {
                Text("MULTIPLICATION\nGAME")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: changeColorOfLargeTitleOnMainScreen ? "05a899" : "ffff00")))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), radius: 10, x: 0, y: 1)
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        , value: changeColorOfLargeTitleOnMainScreen
                    )
                    .onAppear {
                        changeColorOfLargeTitleOnMainScreen.toggle()
                    }
                
                if isEndGame {
                    Spacer()
                    
                    Text("GameOver!")
                        .font(.system(size: 70))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                    
                    Text("Final Score\n\(finalScore)/\(numberOfRounds)")
                        .font(.system(size: 50))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        startButtonSpinDegree += 360
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            play()
                        }
                    }

                } label: {
                    Text(playButtonTitle.uppercased())
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(width: 300, height: 100)
                        .background(Color(UIColor.hexStringToUIColor(hex: "f99d07")))
                        .clipShape(Capsule())
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                .scaleEffect(startButtonSpotlightAnimationAmount)
                                .opacity(2 - startButtonSpotlightAnimationAmount)
                                .animation(
                                    .easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    , value: startButtonSpotlightAnimationAmount)
                            
                        }
                        .onAppear {
                            startButtonSpotlightAnimationAmount = 2
                        }
                        .onDisappear {
                            startButtonSpotlightAnimationAmount = 1.0
                        }
                }
                .rotation3DEffect(.degrees(startButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }

            VStack {
                if settingsToggle == SettingsToggle.on {
                    ZStack {
                        Color(UIColor.hexStringToUIColor(hex: "05a899"))
                            .opacity(0.8)
                            .ignoresSafeArea()
                        
                        VStack () {
                            Spacer()
                            VStack {

                                Text("SETTINGS")
                                    .padding(0)
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 8, x: 5, y: 5)
                                
                                HStack {
                                    Text("Multiplication table")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(multiplicationTable)")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                            .frame(width: 50, height: 20, alignment: .trailing)
                                        
                                        Image(systemName: "list.number")
                                            .scaleEffect(CGSize(width: 1, height: 1))
                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                    }
                                    .gesture (
                                        TapGesture(count: 1)
                                            .onEnded { _ in
                                                withAnimation() {
                                                    showMenuOfMultiplicationTableSelection.toggle()
                                                    showMenuOfNumberOfRoundSelection = false
                                                }
                                            }
                                    )
//                                    .onTapGesture { point in
//                                        withAnimation() {
//                                            showMenuOfMultiplicationTableSelection.toggle()
//                                            showMenuOfNumberOfRoundSelection = false
//                                        }
//                                    }
                                    .overlay {
                                        if showMenuOfMultiplicationTableSelection == true {
                                            VStack {
                                                VStack {
                                                    ForEach(multiplicationTableRange, id: \.self) { index in
                                                        Text("\(index)")
                                                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 10))
                                                            .font(.system(size: multiplicationTable == index || settingsMultiplicationTableHoveredItem == index ? 30 : 18, weight: multiplicationTable == index ? .bold : .regular))
                                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                                            .gesture(
                                                                TapGesture(count: 1)
                                                                    .onEnded({ _ in
                                                                        withAnimation {
                                                                            multiplicationTable = index
                                                                            showMenuOfMultiplicationTableSelection.toggle()
                                                                        }
                                                                    })
                                                            )
//                                                            .onTapGesture {
//                                                                withAnimation {
//                                                                    multiplicationTable = index
//                                                                    showMenuOfMultiplicationTableSelection.toggle()
//                                                                }
//                                                            }
                                                    }
                                                }
                                                .frame(width: 100, height: 380, alignment: .trailing)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                                        .fill(
                                                            LinearGradient(stops: [
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                                                            ], startPoint: .top, endPoint: .bottom)
                                                        )
                                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                                                )
                                            }
                                            .offset(x: -20, y: -210)
                                            .transition(.scale)
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                
                                HStack {
                                    Text("Number of rounds")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(numberOfRounds)")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                            .frame(width: 50, height: 20, alignment: .trailing)
                                        
                                        Image(systemName: "clock.arrow.circlepath")
                                            .scaleEffect(CGSize(width: 1, height: 1))
                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                    }
                                    .gesture(
                                        TapGesture(count: 1)
                                            .onEnded { _ in
                                                withAnimation() {
                                                    showMenuOfNumberOfRoundSelection.toggle()
                                                    showMenuOfMultiplicationTableSelection = false
                                                }
                                            }
                                    )
//                                    .onTapGesture { point in
//                                        withAnimation() {
//                                            showMenuOfNumberOfRoundSelection.toggle()
//                                            showMenuOfMultiplicationTableSelection = false
//                                        }
//                                    }
                                    .overlay {
                                        if showMenuOfNumberOfRoundSelection == true {
                                            VStack {
                                                VStack {
                                                    ForEach(numberOfRoundRange, id: \.self) { index in
                                                        Text("\(index)")
                                                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 10))
                                                            .font(.system(size: numberOfRounds == index ? 30 : 18, weight: numberOfRounds == index ? .bold : .regular))
                                                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    numberOfRounds = index
                                                                    showMenuOfNumberOfRoundSelection.toggle()
                                                                }
                                                            }
                                                    }
                                                }
                                                .frame(width: 100, height: 120, alignment: .trailing)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                                        .fill(
                                                            LinearGradient(stops: [
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                                                            ], startPoint: .top, endPoint: .bottom)
                                                        )
                                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                                                )
                                            }
                                            .offset(x: -20, y: -80)
                                            .transition(.scale)
                                        }
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                
                            }
                            .frame(maxWidth: .infinity, minHeight: 130)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .fill(
                                            LinearGradient(stops: [
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.217),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.218),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                                            ], startPoint: .top, endPoint: .bottom)
                                         )
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                            )
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                            .offset(y: -10)
                        }
                    }
                }
            }
            .gesture(
                TapGesture(count: 1)
                    .onEnded({ _ in
                        withAnimation() {
                            showMenuOfNumberOfRoundSelection = false
                            showMenuOfMultiplicationTableSelection = false
                        }
                    })
            )
//            .onTapGesture {
//                withAnimation() {
//                    showMenuOfNumberOfRoundSelection = false
//                    showMenuOfMultiplicationTableSelection = false
//                }
//            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    withAnimation {
                        switchSettingsPanel()
                    }
                    
                } label: {
                    ZStack {
                        Circle()
                            .fill(Material.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        
                        Image(systemName: settingsToggle == SettingsToggle.off ? "gearshape" : "xmark.circle")
                            //.fontWeight(.bold)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: settingsToggle == SettingsToggle.off ? "05a899" : "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    }
                    
                }
                .rotation3DEffect(.degrees(settingsButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
            }
        }
        .transition(.move(edge: Edge.bottom))
        .animation(.easeOut(duration: 0.5), value: screenType)
    }
    
    func getPlayScreen() -> some View {
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
                            Button {
                                withAnimation {
                                    handleAnswerButtonTapped(answerIndex: answerIndex)
                                }
                                
                            } label: {
                                Text("\(roundAnswers[answerIndex])")
                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                    .font(.system(size: 50))
                                    .fontWeight(.bold)
                                    .frame(width: 300, height: 100)
                                    .background(Color(UIColor.hexStringToUIColor(hex: ((incorrectAnswerButtonAnimations[answerIndex] ?? false) ? "fe2640" : ((correctAnswerButtonAnimations[answerIndex] ?? false) ? "35d461" : "f99d07")))))
                                    .clipShape(Capsule())
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                                    .overlay(content: {
                                        if answerButtonSpotlightAnimationAmounts[answerIndex] ?? 0 > 0 {
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                                                .scaleEffect(answerButtonSpotlightAnimationAmounts[answerIndex] ?? 1.0)
                                                .opacity(2 - (answerButtonSpotlightAnimationAmounts[answerIndex] ?? 1.0))
                                                .animation(
                                                    .easeOut(duration: 1)
                                                    , value: answerButtonSpotlightAnimationAmounts[answerIndex] ?? 1.0
                                                )
                                        }
                                    })
                            }
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    Spacer()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            withAnimation {
                                quitButtonSpinDegree += 360
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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
                                    //.fontWeight(.bold)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "05a899")))
                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                            }
                        }
                        .rotation3DEffect(.degrees(quitButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
                    }
                }
                .transition(.scale)
                .animation(.easeOut(duration: 0.5), value: goNextRound)
            }
        }

    }
    
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
                    getMainScreen()
                case .play:
                    getPlayScreen()
                }
            }
        }
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
