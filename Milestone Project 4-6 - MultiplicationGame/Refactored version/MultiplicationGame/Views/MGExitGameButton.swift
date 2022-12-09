//
//  MGExitGameButton.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import SwiftUI

struct MGExitGameButton: View {
    @EnvironmentObject var playScreenVM: PlayScreenViewModel
    
    var body: some View {
        Button {
            withAnimation {
                playScreenVM.quitButtonSpinDegree += 360
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    playScreenVM.quitPlayingGame()
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50, style: .circular)
                    .fill(Material.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                
                Image(systemName: "xmark.circle")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "05a899")))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
            }
        }
        .offset(y: -5)
        .rotation3DEffect(.degrees(playScreenVM.quitButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
    }
}

struct MGExitGameButton_Previews: PreviewProvider {
    struct SampleView: View {
        @EnvironmentObject var contentVM: ContentViewModel
        
        var body: some View {
            MGExitGameButton()
                .environmentObject(
                    PlayScreenViewModel(
                        numberOfRounds: contentVM.numberOfRounds,
                        multiplicationTable: contentVM.multiplicationTable,
                        runAfterGameIsOver: contentVM.runAfterGameIsOver(_:),
                        runQuitGame: contentVM.runAfterQuittingGame
                    ))
        }
    }
    
    static var previews: some View {
        SampleView()
            .environmentObject(ContentViewModel())
    }
}
