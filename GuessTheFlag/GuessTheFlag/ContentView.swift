//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 9/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingFinalAlertScore = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var alertOfFlagTappedMessage: String = ""
    
    @State private var roundCounter = 0
    let limitedNumberOfRounds = 8
    
    func flagTapped(_ number: Int) {
        var messages = [String]()
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            messages.append("That’s the flag of \(countries[number])")
            score -= 1
        }
        
        messages.append("Your score is \(score)")
        alertOfFlagTappedMessage = messages.joined(separator: "\n")

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
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(color: .white, radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            .alert("GameOver", isPresented: $showingFinalAlertScore) {
                Button("Restart", action: restartGame)
            } message: {
                Text("Final score is \(score)")
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertOfFlagTappedMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
