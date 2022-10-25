//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

@main
struct ContactsApp: App {
    private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
