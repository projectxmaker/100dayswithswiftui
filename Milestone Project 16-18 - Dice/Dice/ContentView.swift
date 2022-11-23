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
    @State private var numberOfDices: Double = 1
    @State private var numberOfPosibilities: Double = 4
//    @State private var dices = [DiceView]()
    @State private var dices = [Dice]()
    @State private var isShowingSettings = false
    @State private var isShowingRollingLogView = false
    
    @State private var triggerSingleTapOnSwitcher = false
    @State private var triggerLongPressOnSwitcher = false
    
    let maximumDices: Double = 50
    let maximumPosibilities: Double = 100
    
    let layouts: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    @State private var results = [Int]()
    
    func generateDices() {
        diceListVM.generateDices(numberOfDices: Int(numberOfDices))
    }
    
    var singleTapOnSwitcher: some Gesture {
        TapGesture()
            .onEnded { _ in
                results.removeAll(keepingCapacity: true)
//                print("what")
//                triggerSingleTapOnSwitcher.toggle()
//                var count = 0
                for eachDice in diceListVM.dices {
//                    count += 1
//                    eachDice.runTimer()
//                    eachDice.invokeSingleTapOnSwitchForOnEnded()
//                    eachDice.roll(postAction: saveLog)
                    eachDice.runSingleTapOnDice()
//                    print(count)
                }
            }
    }
    
    var longPressOnSwitcher: some Gesture {
        LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged({ value in
                if value == .first(true) {
                    results.removeAll(keepingCapacity: true)

                    for eachDice in diceListVM.dices {
                        eachDice.startLongPressOnSwitcher()
                    }
                }
            })
            .onEnded({ value in
//                triggerLongPressOnSwitcher = false
                for eachDice in diceListVM.dices {
                    eachDice.stopLongPressOnSwitcher()
                }
            })
    }

    func saveLog(diceId: UUID, finalResult: Int) {
        guard !dices.filter({ diceView in
            diceView.id == diceId
        }).isEmpty else {
            return
        }

        results.append(finalResult)
        let totalDices = Int(numberOfDices)
        let totalPossibilities = Int(numberOfPosibilities)

        if results.count == totalDices {
            let sortedResults = results.sorted()
            let highestResult = sortedResults.first ?? 0
            let lowestResult = sortedResults.last ?? 0

            diceListVM.saveLog(
                dices: totalDices,
                posibilities: totalPossibilities,
                result: results.map(String.init).joined(separator: ","),
                sumOfResult: results.reduce(0, +),
                highestResult: highestResult,
                lowestResult: lowestResult
            )
        }
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if diceListVM.dices.count == Int(numberOfDices) {
                ScrollView(.vertical) {
                    LazyVGrid(columns: layouts, spacing: 30) {
                        ForEach(diceListVM.dices) { dice in
                            DiceView(
                                dice: dice,
                                triggerSingleTapOnSwitcher: $triggerSingleTapOnSwitcher,
                                triggerLongPressOnSwitcher: $triggerLongPressOnSwitcher,
                                notifyOfGettingFinalResult: saveLog
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 20)
                }
            }
//
//            Text("???? \(diceListVM.hello)")
//                .foregroundColor(.white)
//                .onChange(of: diceListVM.hello) { newValue in
//                    print("change \(newValue)")
//                }
        }
        .sheet(isPresented: $isShowingRollingLogView, content: {
            RollingLogListView()
        })
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
                    .gesture(singleTapOnSwitcher)
                    .gesture(longPressOnSwitcher)
                
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
        .environmentObject(diceListVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
