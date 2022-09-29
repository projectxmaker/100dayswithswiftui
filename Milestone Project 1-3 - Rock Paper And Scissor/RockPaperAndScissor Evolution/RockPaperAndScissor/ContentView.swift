//
//  ContentView.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @State private var items = ContentView.keys.items
    @State private var botChoice: String = ContentView.generateBotChoice()
    @State private var resultStatus = ContentView.generateResult()
    @State private var score: Int = 0
    @State private var round: Int = 1
    @State private var showAlert: Bool = false
    
    @State private var deactivateButtons = false

    func handleButtonTapped(tappedItem: String) {
        deactivateButtons = true
        
        evaluateUserChoice(tappedItem) {
            if isGameOver() {
                showAlert = true
            } else {
                round += 1
                setupDefaultValuesForNewRound()
            }
            
            deactivateButtons = false
        }
    }
    
    func isGameOver() -> Bool {
        return round + 1 > ContentView.keys.limitedRounds
    }
    
    func evaluateUserChoice(_ userChoice: String, execute: @escaping () -> Void) {
        let items = ContentView.keys.items
        
        guard
            let indexOfUserChoice = items.firstIndex(of: userChoice),
            let indexOfBotChoice = items.firstIndex(of: botChoice)
        else {
            return
        }
        
        var result = false
        switch resultStatus {
        case .botWin:
            if indexOfBotChoice - 1 < 0 {
                if indexOfUserChoice == 2 {
                    result = true
                }
            } else {
                if indexOfUserChoice == indexOfBotChoice - 1 {
                    result = true
                }
            }
        case .botLose:
            if indexOfBotChoice + 1 > 2 {
                if indexOfUserChoice == 0 {
                    result = true
                }
            } else {
                if indexOfUserChoice == indexOfBotChoice + 1 {
                    result = true
                }
            }
        }
        
        showCorrespondingEmotionOnItem(matchingResult: result, userChoiceIndex: indexOfUserChoice, execute: execute)
    }
    
    func showCorrespondingEmotionOnItem(matchingResult: Bool, userChoiceIndex: Int, execute: @escaping () -> Void) {
        var emotions = ContentView.keys.emotionForWrongAnswer
        if matchingResult {
            emotions = ContentView.keys.emotionForCorrectAnswer
        }

        let shuffedEmotions = emotions.shuffled()
        let selectedEmotion = shuffedEmotions[0]
        let currentItem = items[userChoiceIndex]
        
        items[userChoiceIndex] = selectedEmotion
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            items[userChoiceIndex] = currentItem
            
            if matchingResult {
                score += 1
            } else {
                score -= 1
            }
            
            execute()
        }
    }
    
    func setupDefaultValuesForNewRound() {
        botChoice = ContentView.generateBotChoice(currentChoice: botChoice)
        resultStatus = ContentView.generateResult()
    }
    
    func restartGame() {
        score = 0
        round = 1
        setupDefaultValuesForNewRound()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: .indigo, location: 0),
                    Gradient.Stop(color: .yellow, location: 0.5),
                    Gradient.Stop(color: .indigo, location: 1)
                ], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
                
                VStack {
                    Text("Round: \(round)")
                        .font(.custom(ContentView.keys.fontName, size: 30))
                        .foregroundColor(.blue)
                        .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                        
                    VStack (spacing: 10) {
                        CircleText(content: $botChoice, backgroundColors: [.white, .indigo, .yellow], shadowColor: .yellow)
                        
                        Text(resultStatus.rawValue)
                            .font(.custom(ContentView.keys.fontName, size: 60))
                            .foregroundColor(.indigo)
                            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        ForEach($items, id: \.self) { item in
                            Button {
                                handleButtonTapped(tappedItem: item.wrappedValue)
                            } label: {
                                CircleText(content: item, backgroundColors: [.gray, .blue, .white], shadowColor: .yellow)
                            }
                            .disabled(deactivateButtons)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .alert("GameOver", isPresented: $showAlert) {
            Button("Restart") {
                // restart game
                restartGame()
            }
        } message: {
            Text("Final Score is \(score)!\n")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
