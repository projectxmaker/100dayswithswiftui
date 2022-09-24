//
//  ContentView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 9/24/22.
//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Hello, world!")
                }
                Button("Tap Count: \(tapCount)") {
                    tapCount += 1
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
