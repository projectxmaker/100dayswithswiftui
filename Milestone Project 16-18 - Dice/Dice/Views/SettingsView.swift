//
//  SettingsView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/24/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var diceListVM: DiceListViewModel
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    var body: some View {
        if voiceOverEnabled {
            HStack {
                VStack (alignment: .leading) {
                    Text("Number of dices: \(Int(diceListVM.numberOfDices))")
                    
                    Button("Increment") {
                        if diceListVM.numberOfDices < 100 {
                            diceListVM.numberOfDices += 1
                        }
                    }
                    
                    Button("Decrement") {
                        if diceListVM.numberOfDices > 0 {
                            diceListVM.numberOfDices -= 1
                        }
                    }
                }
                .onChange(of: diceListVM.numberOfDices) { newValue in
                    diceListVM.generateDices()
                }
                .accessibilityElement()
                .accessibilityLabel("Number of dices")
                .accessibilityValue(String(Int(diceListVM.numberOfDices)))
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment:
                        if diceListVM.numberOfDices < 100 {
                            diceListVM.numberOfDices += 1
                        }
                    case .decrement:
                        if diceListVM.numberOfDices > 0 {
                            diceListVM.numberOfDices -= 1
                        }
                    default:
                        print("Not handled.")
                    }
                }
                
                Spacer()
                
                VStack (alignment: .leading) {
                    Text("Number of possibilities: \(Int(diceListVM.numberOfPossibilities))")
                    
                    Button("Increment") {
                        if diceListVM.numberOfPossibilities < 100 {
                            diceListVM.numberOfPossibilities += 1
                        }
                    }
                    
                    Button("Decrement") {
                        if diceListVM.numberOfPossibilities > 0 {
                            diceListVM.numberOfPossibilities -= 1
                        }
                    }
                }
                .onChange(of: diceListVM.numberOfPossibilities) { newValue in
                    diceListVM.generateDices()
                }
                .accessibilityElement()
                .accessibilityLabel("Number of possibilities")
                .accessibilityValue(String(Int(diceListVM.numberOfPossibilities)))
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment:
                        if diceListVM.numberOfPossibilities < 100 {
                            diceListVM.numberOfPossibilities += 1
                        }
                    case .decrement:
                        if diceListVM.numberOfPossibilities > 0 {
                            diceListVM.numberOfPossibilities -= 1
                        }
                    default:
                        print("Not handled.")
                    }
                }
            }
            .shadow(color: .black, radius: 10, x: 1, y: 1)
            .padding()
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
            .transition(.move(edge: .top).combined(with: .opacity))
        } else {
            VStack {
                VStack (alignment: .leading) {
                    Text("Dices: \(Int(diceListVM.numberOfDices))")
                    Slider(value: $diceListVM.numberOfDices, in: 0...diceListVM.maximumDices, step: 1)
                        .onChange(of: diceListVM.numberOfDices) { newValue in
                            diceListVM.generateDices()
                        }
                }
                VStack (alignment: .leading) {
                    Text("Possibilities: \(Int(diceListVM.numberOfPossibilities))")
                    Slider(value: $diceListVM.numberOfPossibilities, in: 0...diceListVM.maximumPossibilities, step: 1)
                        .onChange(of: diceListVM.numberOfPossibilities) { newValue in
                            diceListVM.generateDices()
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
