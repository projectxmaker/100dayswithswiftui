//
//  ContactFriend+CoreDataProperties.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/24/22.
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
    @NSManaged public var user: Contact?

    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }
}

extension ContactFriend : Identifiable {

}
