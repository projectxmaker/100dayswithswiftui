//
//  ContentView.swift
//  Flashzilla
//
//  Created by Pham Anh Tuan on 11/11/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var cards: Cards
    
    @State private var isActive = true
    @State private var cardList = [Card]()

    @State private var timeRemaining = 100
    @State private var showingEditScreen = false
    @State private var counter = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func loadData() {
        cardList = cards.list
    }
    
    func removeCard(_ card: Card, answerType: AnswerType = .correct) {
        guard
            !cardList.isEmpty,
            let indexOfTobeRemoveCard = cardList.firstIndex(of: card)
        else { return }
        
        cardList.remove(at: indexOfTobeRemoveCard)
        
        // in case answer is wrong, move this card to the bottom of the stack
        if answerType == .wrong {
            var newCard = card
            newCard.id = UUID()
            cardList.insert(newCard, at: 0)
        }
        
        if cardList.isEmpty {
            isActive = false
        }
    }
    
    func resetcardList() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(cardList) { card in
                        CardView(card: card) { answerType in
                            withAnimation {
                                removeCard(card, answerType: answerType)
                            }
                        }
                        .stacked(at: cardList.firstIndex(of: card) ?? 0, in: cardList.count)
                        .allowsHitTesting((cardList.firstIndex(of: card) ?? 0) == cardList.count - 1)
                        .accessibilityHidden((cardList.firstIndex(of: card) ?? 0) < cardList.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cardList.isEmpty {
                    Button("Start Again", action: resetcardList)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCard(cardList[cardList.count - 1])
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                //removeCard(at: cardList.count - 1)
                                removeCard(cardList[cardList.count - 1])
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cardList.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetcardList, content: EditCards.init)
        .onAppear(perform: resetcardList)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
