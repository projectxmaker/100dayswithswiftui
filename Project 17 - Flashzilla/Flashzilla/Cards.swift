//
//  Cards.swift
//  Flashzilla
//
//  Created by Pham Anh Tuan on 11/13/22.
//

import SwiftUI

@MainActor class Cards: ObservableObject {
    @Published private(set) var list: [Card]
    let fileName = "cards"

    init() {
        if let decodedData = FileManager.default.decodeJSON(fileName) as [Card]? {
            list = decodedData
            return
        }
        
        list = []
    }
    
    private func save() {
        _ = FileManager.default.encodeJSON(fileName, fileData: list)
    }
    
    func add(_ card: Card) {
        list.insert(card, at: 0)
        save()
    }
    
    func delete(atOffsets: IndexSet) {
        list.remove(atOffsets: atOffsets)
        save()
    }
}

