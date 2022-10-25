//
//  UserManager.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import CoreData
import SwiftUI

struct ContactManager {
    let userInfoURL = "https://www.hackingwithswift.com/samples/friendface.json"
    
    init() {
    }
    
    
    // MARK: - Extra Funcs
    func loadData(moc: NSManagedObjectContext, execute: (Bool) -> Void) async {
        guard let url = URL(string: userInfoURL)
        else {
            execute(false)
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedContacts = try JSONDecoder().decode([ContactModel].self, from: data)
            
            insertRemoteDataIntoDatabase(moc: moc, contacts: decodedContacts)
            execute(true)
        } catch {
            execute(false)
        }
    }
    
    func insertRemoteDataIntoDatabase(moc: NSManagedObjectContext, contacts: [ContactModel]) {
        for contact in contacts {
            let newContact = Contact(context: moc)
            newContact.age = Int16(contact.age)
            newContact.name = contact.name
            newContact.company = contact.company
            newContact.email = contact.email
            newContact.registered = try? Date(contact.registered, strategy: .iso8601)
            newContact.about = contact.about
            newContact.address = contact.address
            newContact.isActive = contact.isActive
            newContact.tags = contact.tags.joined(separator: ", ")
            
            for friend in contact.friends {
                let newFriend = ContactFriend(context: moc)
                newFriend.id = friend.id
                newFriend.name = friend.name
                newContact.addToFriends(newFriend)
            }
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
