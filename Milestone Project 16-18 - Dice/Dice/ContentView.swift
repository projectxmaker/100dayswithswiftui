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
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                DiceView(visibleValue: $visibleValue)
//                DiceView(
//                    visibleValue: $visibleValue,
//                    numberOfSides: 8,
//                    shadowColor: .white,
//                    switcherForgroundColorEnabled: .white,
//                    switcherForgroundColorDisabled: .gray
//                )
            }
            .padding()
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
