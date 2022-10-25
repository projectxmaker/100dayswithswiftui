//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/24/22.
//
//

import Foundation
import CoreData


extension Contact {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: NSSet?
    
    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedAge: Int {
        Int(age)
    }
    
    var wrappedCompany: String {
        company ?? ""
    }
    
    var wrappedEmail: String {
        email ?? ""
    }
    
    var wrappedAddress: String {
        address ?? ""
    }
    
    var wrappedAbout: String {
        about ?? ""
    }
    
    var wrappedRegistered: String {
        guard let registeredDate = registered else {
            return ""
        }
    
        return registeredDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var wrappedTags: String {
        tags ?? ""
    }
    
    var friendsArray: [ContactFriend] {
        let set = friends as? Set<ContactFriend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for friends
extension Contact {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: ContactFriend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: ContactFriend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension Contact : Identifiable {

}
