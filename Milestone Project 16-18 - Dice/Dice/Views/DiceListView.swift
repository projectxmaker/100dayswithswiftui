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

    fileprivate func extractedFunc(_ dice: Dice) -> DiceView {
        return DiceView(
            dice: dice,
            shadowColorIfPressingSwitcher: Color.white,
            shadowColorWhenDiceIsRolling: Color.black,
            width: 90,
            height: 70,
            switcherForgroundColorEnabled: Color.white,
            switcherForgroundColorDisabled: Color.gray
        )
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView(.vertical) {
                LazyVGrid(columns: layouts, spacing: 30) {
                    ForEach(diceListVM.dices) { dice in
                        extractedFunc(dice)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 20)
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
            BottomPanelView(
                powerSwitcherForgroundColorDisabled: Color.gray,
                powerSwitcherForgroundColorEnabled: Color.white
            )
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
