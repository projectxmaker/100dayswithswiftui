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
    @State private var numberOfDices = 0
    @State private var dices = [DiceView]()
    
    let layouts: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    func generateDices(_ newNumberOfDices: Int) {
        dices = Array.init(repeating: DiceView(
            numberOfSides: 100,
            shadowColor: .white,
            width: 90,
            height: 80,
            switcherForgroundColorEnabled: .white,
            switcherForgroundColorDisabled: .gray
        ), count: newNumberOfDices)
        
        numberOfDices = newNumberOfDices
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVGrid(columns: layouts, spacing: 30) {
                    ForEach(0..<numberOfDices, id: \.self) { index in
                        dices[index]
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Text("Number of Dices: \(numberOfDices)")
                Spacer()
                Button {
                    let newNumberOfDices = numberOfDices > 0 ? numberOfDices - 1 : 0
                    generateDices(newNumberOfDices)
                } label: {
                    Image(systemName: "minus.square.fill")
                        .font(.title)
                }
                Button {
                    let newNumberOfDices = numberOfDices + 1
                    generateDices(newNumberOfDices)
                } label: {
                    Image(systemName: "plus.square.fill")
                        .font(.title)
                }
            }
            .shadow(color: .black, radius: 10, x: 1, y: 1)
            .padding()
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
