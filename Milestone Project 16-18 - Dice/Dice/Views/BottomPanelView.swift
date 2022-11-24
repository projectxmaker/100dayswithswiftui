//
//  BottomPanelView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/24/22.
//

import SwiftUI

struct BottomPanelView: View {
    @EnvironmentObject var diceListVM: DiceListViewModel
    
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
            
            Spacer()
            
            Image(systemName: "square.dashed.inset.filled")
                .font(.largeTitle.bold())
                .buttonStyle(.plain)
                .gesture(diceListVM.singleTapOnSwitcher)
                .gesture(diceListVM.longPressOnSwitcher)
            
            Spacer()
            
            Button {
                withAnimation {
                    diceListVM.isShowingSettings.toggle()
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
}

struct BottomPanelView_Previews: PreviewProvider {
    static var previews: some View {
        BottomPanelView()
    }
}
