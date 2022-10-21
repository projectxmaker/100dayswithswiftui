//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Pham Anh Tuan on 10/21/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var controller = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
