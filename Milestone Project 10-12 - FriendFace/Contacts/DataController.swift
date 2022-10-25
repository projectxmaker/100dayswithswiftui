//
//  DataController.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import CoreData

class DataController {
    let container = NSPersistentContainer(name: "ContactsModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Cannot load data \(error.localizedDescription)")
            }
        }
    }
}
