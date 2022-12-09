//
//  MGAnswerButtons.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import SwiftUI

struct MGAnswerButtons: View {
    @EnvironmentObject var playScreenVM: PlayScreenViewModel
    
    var body: some View {
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
    }
}

struct MGAnswerButtons_Previews: PreviewProvider {
    
    struct SampleView: View {
        @EnvironmentObject var contentVM: ContentViewModel
        
        var body: some View {
            MGAnswerButtons()
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
