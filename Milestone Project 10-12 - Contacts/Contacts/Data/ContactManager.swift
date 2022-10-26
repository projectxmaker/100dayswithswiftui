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
    
    // MARK: - Extra Funcs
    func loadData(moc: NSManagedObjectContext, execute: ((Bool, Bool) -> Void)? = nil) async {
        guard let url = URL(string: userInfoURL)
        else {
            if let execute = execute {
                execute(true, false)
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedContacts = try decoder.decode([ContactModel].self, from: data)
            
            await MainActor.run(body: {
                insertRemoteDataIntoDatabase(moc: moc, contacts: decodedContacts)
                if let execute = execute {
                    execute(true, decodedContacts.isEmpty ? false : true)
                }
            })
        } catch {
            if let execute = execute {
                execute(true, false)
            }
        }
    }
    
    func insertRemoteDataIntoDatabase(moc: NSManagedObjectContext, contacts: [ContactModel]) {
        var tags = [String: Tag]()
        var friends = [String: ContactFriend]()
        
        for contact in contacts {
            let newContact = Contact(context: moc)
            newContact.id = contact.id
            newContact.age = Int16(contact.age)
            newContact.name = contact.name
            newContact.company = contact.company
            newContact.email = contact.email
            newContact.registered = contact.registered
            newContact.about = contact.about
            newContact.address = contact.address
            newContact.isActive = contact.isActive

            for tag in contact.tags {
                // use existing tag if it exists already
                if let existingTag = tags[tag] {
                    newContact.addToTags(existingTag)
                } else {
                    let newTag = Tag(context: moc)
                    newTag.id = UUID()
                    newTag.name = tag
                    tags[tag] = newTag

                    newContact.addToTags(newTag)
                }
            }
            
            for friend in contact.friends {
                // use existing tag if it exists already
                if let existingFriend = friends[friend.id] {
                    newContact.addToFriends(existingFriend)
                } else {
                    let newFriend = ContactFriend(context: moc)
                    newFriend.id = friend.id
                    newFriend.name = friend.name
                    friends[friend.id] = newFriend
                    
                    newContact.addToFriends(newFriend)
                }
            }
        }

        if moc.hasChanges {
            try? moc.save()
        }
    }
}
