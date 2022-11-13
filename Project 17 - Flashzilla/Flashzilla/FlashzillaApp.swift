//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Pham Anh Tuan on 11/11/22.
//

import SwiftUI

@main
struct FlashzillaApp: App {
    @StateObject var cards = Cards()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cards)
        }
    }
}
