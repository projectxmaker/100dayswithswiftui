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
                        
                        VStack(spacing: 20) {
                            ForEach(playScreenVM.roundAnswers.indices, id: \.self) { answerIndex in
                                MGAnswerButton(
                                    action: {
                                        withAnimation {
                                            playScreenVM.handleAnswerButtonTapped(answerIndex: answerIndex)
                                        }
                                        
                                    }, label: "\(playScreenVM.roundAnswers[answerIndex])"
                                    , fontSize: 50, width: 300, height: 100
                                    , backgroundColor:  ((playScreenVM.incorrectAnswerButtonAnimations[answerIndex] ?? false) ? "fe2640" : ((playScreenVM.correctAnswerButtonAnimations[answerIndex] ?? false) ? "35d461" : "f99d07"))
                                    , spotlightAnimationAmount: playScreenVM.answerButtonSpotlightAnimationAmounts[answerIndex] ?? 0
                                    , spinDegreeWhenButtonTapped: playScreenVM.roundAnswerButtonAnimations[answerIndex] ?? 0.0
                                    , hideAnimation: playScreenVM.hideCorrectAnswerButtonAnimations[answerIndex] ?? false
                                    , isCorrectButtonTapped: playScreenVM.showScoreForTappingOnCorrectAnswerButtonAnimations[answerIndex] ?? false
                                )
                            }
                        }
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
    }
}
