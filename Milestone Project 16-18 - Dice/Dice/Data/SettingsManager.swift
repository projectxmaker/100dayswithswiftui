//
//  SettingsManager.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/24/22.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    var settings: Settings
    
    let settingsFile = "Settings"
    
    init() {
        guard let settings = FileManager.default.decodeJSON(settingsFile) as Settings? else {
            self.settings = Settings()
            return
        }
         
        self.settings = settings
    }
    
    func save() {
        _ = FileManager.default.encodeJSON(settingsFile, fileData: settings)
        
        print("saved! \(settings)")
    }
}
