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
    var created = Date.now
    
    var createdDescription: String {
        return created.formatted(date: .abbreviated, time: .shortened)
    }
}

enum SortType: String, CaseIterable {
    case byNameAscending = "Sort by Name in ascending order"
    case byNameDescending = "Sort by Name in descending order"
    case byMostRecentAscending = "Sort by Most Recent in ascending order"
    case byMostRecentDescending = "Sort by Most Recent in descending order"
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
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
    
    func sort(_ sortType: SortType) {
        switch sortType {
        case .byNameAscending:
            people = people.sorted(by: { lhs, rhs in
                lhs.name < rhs.name
            })
            
        case .byNameDescending:
            people = people.sorted(by: { lhs, rhs in
                lhs.name > rhs.name
            })

        case .byMostRecentAscending:
            people = people.sorted(by: { lhs, rhs in
                lhs.created < rhs.created
            })
            
        case .byMostRecentDescending:
            people = people.sorted(by: { lhs, rhs in
                lhs.created > rhs.created
            })
        }
    }
}
