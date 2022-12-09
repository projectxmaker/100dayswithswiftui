//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Pham Anh Tuan on 9/26/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
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

                        Text(vm.countries[vm.correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            vm.flagTapped(number)
                        } label: {
                            FlagImageView(showAnimation: vm.showFlagAnimations[number], isNotChosen: vm.flagsNotChosen[number], imageName: vm.countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(vm.score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            .alert("GameOver", isPresented: $vm.showingFinalAlertScore) {
                Button("Restart", action: vm.restartGame)
            } message: {
                Text("Final score is \(vm.score)")
            }
        }
        .alert(vm.scoreTitle, isPresented: $vm.showingScore) {
            Button("Continue", action: vm.askQuestion)
        } message: {
            Text(vm.alertOfFlagTappedMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
