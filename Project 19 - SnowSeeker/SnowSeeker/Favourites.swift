//
//  Favourites.swift
//  SnowSeeker
//
//  Created by Pham Anh Tuan on 12/12/22.
//

import SwiftUI

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"
    
    let jsonFileName = "favourite-resorts"

    init() {
        // load our saved data
        guard let resorts = FileManager.default.decodeJSON(jsonFileName) as Set<String>? else {
            self.resorts = []
            return
        }
        
        // still here? Use an empty array
        self.resorts = resorts
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        let _ = FileManager.default.encodeJSON(self.jsonFileName, fileData: self.resorts)
    }
}
