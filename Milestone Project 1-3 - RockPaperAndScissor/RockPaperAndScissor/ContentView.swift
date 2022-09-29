//
//  ContentView.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @State private var botChoice: String = ContentView.generateBotChoice()
    @State private var resultStatus = ContentView.generateResult()
    @State private var score: Int = 0
    
    let fontName = "Chalkduster"
    
    @State private var round: Int = 1
    
    func handleButtonTapped(tappedItem: String) {
        if evaluateUserChoice(tappedItem) {
            score += 1
        } else {
            score -= 1
        }
        
        setupDefaultValuesForNewRound()
        
        round += 1
    }
    
    func evaluateUserChoice(_ userChoice: String) -> Bool {
        let items = ContentView.keys.items
        
        guard
            let indexOfUserChoice = items.firstIndex(of: userChoice),
            let indexOfBotChoice = items.firstIndex(of: botChoice)
        else {
            return false
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
        
        return result
    }
    
    func setupDefaultValuesForNewRound() {
        botChoice = ContentView.generateBotChoice()
        resultStatus = ContentView.generateResult()
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
                        .font(.custom(fontName, size: 30))
                        .foregroundColor(.blue)
                        .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                        
                    VStack (spacing: 10) {
                        CircleText(content: botChoice, backgroundColors: [.white, .indigo, .yellow], shadowColor: .yellow)
                        
                        Text(resultStatus.rawValue)
                            .font(.custom(fontName, size: 60))
                            .foregroundColor(.indigo)
                            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        ForEach(ContentView.keys.items, id: \.self) { item in
                            Button {
                                handleButtonTapped(tappedItem: item)
                            } label: {
                                CircleText(content: item, backgroundColors: [.gray, .blue, .white], shadowColor: .yellow)
                            }
                        }
                    }
                    
                    Spacer()
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
