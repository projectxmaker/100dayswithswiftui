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
        VStack {
            VStack (alignment: .leading) {
                if voiceOverEnabled {
                    Stepper(
                        "Number of dices: \(Int(diceListVM.numberOfDices))",
                        value: $diceListVM.numberOfDices,
                        in: 0...diceListVM.maximumDices,
                        step: 1)
                    .onChange(of: diceListVM.numberOfDices) { newValue in
                        diceListVM.generateDices()
                    }
                } else {
                    Text("Dices: \(Int(diceListVM.numberOfDices))")
                    Slider(value: $diceListVM.numberOfDices, in: 0...diceListVM.maximumDices, step: 1)
                        .onChange(of: diceListVM.numberOfDices) { newValue in
                            diceListVM.generateDices()
                        }
                }
            }
            VStack (alignment: .leading) {
                if voiceOverEnabled {
                    Stepper(
                        "Number of possibilities of a dice: \(Int(diceListVM.numberOfPossibilities))",
                        value: $diceListVM.numberOfPossibilities,
                        in: 0...diceListVM.maximumPossibilities,
                        step: 1)
                    .onChange(of: diceListVM.numberOfPossibilities) { newValue in
                        diceListVM.generateDices()
                    }
                } else {
                    Text("Possibilities: \(Int(diceListVM.numberOfPossibilities))")
                    Slider(value: $diceListVM.numberOfPossibilities, in: 0...diceListVM.maximumPossibilities, step: 1)
                        .onChange(of: diceListVM.numberOfPossibilities) { newValue in
                            diceListVM.generateDices()
                        }
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
