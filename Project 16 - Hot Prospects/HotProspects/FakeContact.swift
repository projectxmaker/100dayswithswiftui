//
//  FakeContact.swift
//  HotProspects
//
//  Created by Pham Anh Tuan on 11/10/22.
//

import Foundation

class FakeContact: Identifiable, Codable {
    var name = "Anonymous"
    var email = "paul@hackingwithswift.com"
}

class FakeContacts: ObservableObject {
    let fileFakeContact = "FakeContacts.json"
    var fakeContacts: [FakeContact]

    init() {
        self.fakeContacts = Bundle.main.decode(self.fileFakeContact)
    }
    
    func getRandomFakeContactString() -> String {
        
        
        let fakeContact = fakeContacts.randomElement() ?? FakeContact()
        return "\(fakeContact.name)\n\(fakeContact.email)"
    }
    
}
