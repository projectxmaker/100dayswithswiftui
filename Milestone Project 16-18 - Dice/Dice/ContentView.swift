//
//  ContentView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var diceListVM = DiceListViewModel()
    
    @State private var switcher = false
    @State private var visibleValue = 1
    @State private var isShowingSettings = false
    @State private var isShowingRollingLogView = false
    
    let layouts: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    @State private var results = [Int]()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if diceListVM.dices.count == Int(diceListVM.numberOfDices) {
                ScrollView(.vertical) {
                    LazyVGrid(columns: layouts, spacing: 30) {
                        ForEach(diceListVM.dices) { dice in
                            DiceView(
                                dice: dice,
                                width: 90,
                                height: 70
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 20)
                }
            }
        }
        .sheet(isPresented: $isShowingRollingLogView, content: {
            RollingLogListView()
        })
        .safeAreaInset(edge: .top) {
            if isShowingSettings {
                VStack {
                    VStack (alignment: .leading) {
                        Text("Dices: \(Int(diceListVM.numberOfDices))")
                        Slider(value: $diceListVM.numberOfDices, in: 0...diceListVM.maximumDices, step: 1)
                            .onChange(of: diceListVM.numberOfDices) { newValue in
                                diceListVM.generateDices()
                            }
                    }
                    VStack (alignment: .leading) {
                        Text("Posibilities: \(Int(diceListVM.numberOfPossibilities))")
                        Slider(value: $diceListVM.numberOfPossibilities, in: 0...diceListVM.maximumPossibilities, step: 1)
                            .onChange(of: diceListVM.numberOfPossibilities) { newValue in
                                diceListVM.generateDices()
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
                        isShowingRollingLogView.toggle()
                    }
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title3)
                }
                
                Spacer()
                
                Image(systemName: "square.dashed.inset.filled")
                    .font(.largeTitle.bold())
                    .buttonStyle(.plain)
                    .gesture(diceListVM.singleTapOnSwitcher)
                    .gesture(diceListVM.longPressOnSwitcher)
                
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
            diceListVM.generateDices()
        }
        .environmentObject(diceListVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
