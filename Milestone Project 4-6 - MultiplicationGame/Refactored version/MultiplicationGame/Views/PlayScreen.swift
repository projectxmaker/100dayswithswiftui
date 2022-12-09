//
//  GameEngine.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct PlayScreen: View {
    @StateObject var playScreenVM: PlayScreenViewModel
    @EnvironmentObject var contentVM: ContentViewModel
    
    init(numberOfRounds: Int, multiplicationTable: Int, runAfterGameIsOver: @escaping (_: Int) -> Void, runQuitGame: @escaping () -> Void) {
        _playScreenVM = StateObject.init(wrappedValue: PlayScreenViewModel(
            numberOfRounds: numberOfRounds,
            multiplicationTable: multiplicationTable,
            runAfterGameIsOver: runAfterGameIsOver,
            runQuitGame: runQuitGame))
    }
    
    var body: some View {
        ZStack {
            VStack {
                if playScreenVM.goNextRound {
                    VStack {
                        Text("ROUND \(playScreenVM.numberOfGeneratedRightOperands)/\(playScreenVM.numberOfRounds)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), radius: 10, x: 0, y: 1)
                        
                        Spacer()
                        
                        Text(playScreenVM.roundQuestion)
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        
                        
                        Spacer()
                        
                        MGAnswerButtons()
                        
                        Spacer()
                        Spacer()
                    }
                    .scaleEffect(playScreenVM.roundContentShowUp ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: playScreenVM.roundContentRotationDegree), axis: (x: 0, y: 1, z: 0))
                    .animation(.easeOut(duration: 0.5), value: playScreenVM.roundContentRotationDegree)
                }
            }
            .onAppear {
                playScreenVM.startRound()
            }
            
            VStack {
                Spacer()
                
                MGExitGameButton()
            }
        }
        .environmentObject(playScreenVM)
    }
}


struct PlayScreen_Previews: PreviewProvider {
    struct SampleView: View {
        @EnvironmentObject var vm: ContentViewModel
        var body: some View {
            PlayScreen(
                numberOfRounds: vm.numberOfRounds,
                multiplicationTable: vm.multiplicationTable,
                runAfterGameIsOver: vm.runAfterGameIsOver(_:),
                runQuitGame: vm.runAfterQuittingGame)
        }
    }
    static var previews: some View {
        SampleView()
            .environmentObject(ContentViewModel())
    }
}
