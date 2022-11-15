//
//  ContentView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct ContentView: View {
    @State private var switcher = false
    @State private var visibleValue = 1
    
    var body: some View {
        VStack {
            DiceView(switcher: $switcher, visibleValue: $visibleValue)
            
            Button {
                switcher.toggle()
            } label: {
                Text("Switcher")
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
