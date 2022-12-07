//
//  Constants.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/29/22.
//

import Foundation
import SwiftUI

enum ResultStatus: LocalizedStringKey, CaseIterable {
    case playerWin = "Win"
    case playerLose = "Lose"
    case playerDraw = "Draw"
}

extension ContentView {
    struct keys {
        static let items: [String] = [
            "✊",
            "🖐",
            "✌️",
        ]
        
        static let limitedRounds: Int = 10
        
        static let fontName = "Chalkduster"
        
        static let emotionForWrongAnswer: [String] = ["😭","😤","😱","😖"]
        static let emotionForCorrectAnswer: [String] = ["🥳","🤩","🥰","😍"]
        
        static let emotionDisplayDelay: Double = 0.4
    }
    
    static func generateBotChoice(currentChoice: String? = nil) -> String {
        var items = ContentView.keys.items
        if let currentChoice {
            if let tobeRemovedIndex = items.firstIndex(of: currentChoice) {
                items.remove(at: tobeRemovedIndex)
            }
        }
        let shuffedItems = items.shuffled()
        return shuffedItems[0]
    }
    
    static func generateResult() -> ResultStatus {
        ResultStatus.allCases.randomElement() ?? ResultStatus.playerWin
    }
}
