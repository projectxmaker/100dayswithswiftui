//
//  Tag+CoreDataProperties.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/25/22.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var contact: NSSet?

    var wrappedId: String {
        id?.uuidString ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }
}

// MARK: Generated accessors for contact
extension Tag {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

extension Tag : Identifiable {

}
