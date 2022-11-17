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
    @State private var numberOfDices: Double = 1
    @State private var numberOfPosibilities: Double = 4
    @State private var dices = [DiceView]()
    @State private var isShowingSettings = false
    
    let maximumDices: Double = 50
    let maximumPosibilities: Double = 100
    
    let layouts: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    func generateDices() {
        dices.removeAll()
        for _ in 0..<Int(numberOfDices) {
            let newDice = DiceView(
                numberOfSides: Int(numberOfPosibilities),
                shadowColor: .cyan,
                shadowColorIfPressingSwitcher: .cyan,
                shadowColorWhenDiceIsRolling: .white,
                width: 90,
                height: 80,
                switcherForgroundColorEnabled: .cyan.opacity(0.9),
                switcherForgroundColorDisabled: .gray)
                
            dices.append(newDice)
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if dices.count == Int(numberOfDices) {
                ScrollView(.vertical) {
                    LazyVGrid(columns: layouts, spacing: 30) {
                        ForEach(dices, id: \.id) { dice in
                            dice
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 20)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            if isShowingSettings {
                VStack {
                    VStack (alignment: .leading) {
                        Text("Dices: \(Int(numberOfDices))")
                        Slider(value: $numberOfDices, in: 0...maximumDices, step: 1)
                            .onChange(of: numberOfDices) { newValue in
                                generateDices()
                            }
                    }
                    VStack (alignment: .leading) {
                        Text("Posibilities: \(Int(numberOfPosibilities))")
                        Slider(value: $numberOfPosibilities, in: 0...maximumPosibilities, step: 1)
                            .onChange(of: numberOfPosibilities) { newValue in
                                generateDices()
                            }
                    }
                }
                .shadow(color: .black, radius: 10, x: 1, y: 1)
                .padding()
                .foregroundColor(.white)
                .background(.ultraThinMaterial)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    withAnimation(.easeIn(duration: 0.5)) {
                        isShowingSettings.toggle()
                    }
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title3)
                }
                Spacer()
                Button {
                    withAnimation {
                        isShowingSettings.toggle()
                    }
                } label: {
                    Image(systemName: "square.dashed.inset.filled")
                        .font(.largeTitle.bold())
                }
                Spacer()
                Button {
                    withAnimation {
                        isShowingSettings.toggle()
                    }
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title3)
                }
            }
            .shadow(color: .black, radius: 10, x: 1, y: 1)
            .padding()
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
        }
        .task {
            generateDices()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
