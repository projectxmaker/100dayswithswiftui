//
//  DiceListView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/24/22.
//

import SwiftUI

struct DiceListView: View {
    @StateObject private var diceListVM = DiceListViewModel()
    
    let layouts: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]

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
        .sheet(isPresented: $diceListVM.isShowingRollingLogView, content: {
            RollingLogListView()
        })
        .safeAreaInset(edge: .top) {
            if diceListVM.isShowingSettings {
                SettingsView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            BottomPanelView()
        }
        .task {
            diceListVM.generateDices()
        }
        .environmentObject(diceListVM)
    }
}

struct DiceListView_Previews: PreviewProvider {
    static var previews: some View {
        DiceListView()
    }
}
