//
//  Prospect.swift
//  HotProspects
//
//  Created by Pham Anh Tuan on 11/10/22.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let fileName = "prospects"

    init() {
        if let decodedData = FileManager.default.decodeJSON(fileName) as [Prospect]? {
            people = decodedData
            return
        }
        
        people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    private func save() {
        _ = FileManager.default.encodeJSON(fileName, fileData: people)
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}
