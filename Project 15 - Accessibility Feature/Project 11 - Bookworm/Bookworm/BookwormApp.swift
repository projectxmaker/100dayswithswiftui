//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Pham Anh Tuan on 10/20/22.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var controller = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
