//
//  Constants.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/29/22.
//

import Foundation

enum ResultStatus: String, CaseIterable {
    case botWin = "Win"
    case botLose = "Lose"
}

extension ContentView {
    struct keys {
        static let items: [String] = [
            "✊",
            "🖐",
            "✌️",
        ]
    }
    
    static func generateBotChoice() -> String {
        let shuffedItems = ContentView.keys.items.shuffled()
        return shuffedItems[0]
    }
    
    static func generateResult() -> ResultStatus {
        ResultStatus.allCases.randomElement() ?? ResultStatus.botWin
    }
}
