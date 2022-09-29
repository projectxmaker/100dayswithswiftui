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
    
    func handleButtonTapped(tappedItem: String) {
        if tappedItem == botChoice {
            score += 1
        } else {
            score -= 1
        }
        setupDefaultValuesForNewRound()
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
                    Spacer()
                    
                    Text("Score: \(score)")
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
