//
//  DataController.swift
//  CoreDataProject
//
//  Created by Pham Anh Tuan on 10/21/22.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataProject")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Cannot load data \(error.localizedDescription)")
            }
        }
    }
}
