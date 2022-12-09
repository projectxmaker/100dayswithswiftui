//
//  ContentViewModel.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    enum ScreenType {
        case main
        case play
    }
    

    @Published var multiplicationTable = 2
    @Published var numberOfRounds = 5
    @Published var playButtonTitle = "Start"
    @Published var isEndGame = false
    @Published var finalScore = 0
    
    var screenType = ScreenType.main
    private var changeColorOfLargeTitleOnMainScreen = false
    private var roundAnswers = [Int]()
    private var roundCorrectAnswer = 0
    private var inPlay = false

    func runAfterGameIsOver(_ finalScore: Int) {
        isEndGame = true
        self.finalScore = finalScore
        playButtonTitle = "Restart"
        screenType = ScreenType.main
    }
    
    func runAfterQuittingGame() {
        screenType = ScreenType.main
        isEndGame = false
        finalScore = 0
        playButtonTitle = "Start"
    }
    
    func playGame() {
        screenType = ScreenType.play
    }
}
