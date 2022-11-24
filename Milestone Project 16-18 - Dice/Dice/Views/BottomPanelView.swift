//
//  BottomPanelView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/24/22.
//

import SwiftUI

struct BottomPanelView: View {
    @EnvironmentObject var diceListVM: DiceListViewModel
    
    var powerSwitcherForgroundColorDisabled = Color.black
    var powerSwitcherForgroundColorEnabled = Color.gray
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    diceListVM.isShowingRollingLogView.toggle()
                }
            } label: {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title3)
            }
            .accessibilityRemoveTraits(.isImage)
            .accessibilityLabel("History")
            .accessibilityHint("Tap to show History panel moves from the bottom of screen")
            
            Spacer()
            
            Image(systemName: "square.dashed.inset.filled")
                .font(.largeTitle.bold())
                .foregroundColor(diceListVM.isRollingMultipleDicesByPowerSwitcher ? powerSwitcherForgroundColorDisabled : powerSwitcherForgroundColorEnabled)
                .scaleEffect(diceListVM.isPressingOnPowerSwitcher ? 0.8 : 1)
                .buttonStyle(.plain)
                .gesture(diceListVM.singleTapOnSwitcher)
                .gesture(diceListVM.longPressOnSwitcher)
                .accessibilityRemoveTraits(.isImage)
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("Power Switcher")
                .accessibilityHint("Tap to roll all Dices")
                .animation(.easeIn(duration: 0.1), value:  diceListVM.isPressingOnPowerSwitcher)
            
            Spacer()
            
            Button {
                withAnimation {
                    diceListVM.isShowingSettings.toggle()
                }
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
            .accessibilityRemoveTraits(.isImage)
            .accessibilityLabel("Settings")
            .accessibilityHint("Tap to show Settings panel moves from the top of screen")
        }
        .shadow(color: .black, radius: 10, x: 1, y: 1)
        .padding()
        .foregroundColor(.white)
        .background(.ultraThinMaterial)
    }
}

struct BottomPanelView_Previews: PreviewProvider {
    static var previews: some View {
        BottomPanelView()
    }
}
