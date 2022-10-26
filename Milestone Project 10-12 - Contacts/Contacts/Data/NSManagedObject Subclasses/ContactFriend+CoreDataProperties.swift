//
//  ContactFriend+CoreDataProperties.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/26/22.
//
//

import Foundation
import CoreData


extension ContactFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactFriend> {
        return NSFetchRequest<ContactFriend>(entityName: "ContactFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var contacts: NSSet?

    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }
    
    var contactsArray: [Contact] {
        let set = contacts as? Set<Contact> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for contacts
extension ContactFriend {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

extension ContactFriend : Identifiable {

}
