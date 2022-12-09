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

    func showMainScreen() -> some View {
        MainScreen(
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
        isEndGame = false
        finalScore = 0
        playButtonTitle = "Start"
    }
    
    func showPlayScreen() -> some View {
        PlayScreen(
            numberOfRounds: $numberOfRounds,
            multiplicationTable: $multiplicationTable,
            runAfterGameIsOver: runAfterGameIsOver(_:),
            runQuitGame: funAfterQuittingGame)
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
                    showMainScreen()
                case .play:
                    showPlayScreen()
                }
            }
        }
    }
    
    // MARK: - body
    var body: some View {
        getAppContent()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
