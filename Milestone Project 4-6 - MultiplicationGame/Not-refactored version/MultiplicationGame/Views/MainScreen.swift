//
//  MainScreen.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MainScreen: View {
    @State private var showMenuOfMultiplicationTableSelection = false
    @State private var showMenuOfNumberOfRoundSelection = false
    @State private var settingsButtonSpinDegree: Double = 0
    @State private var startButtonSpinDegree: Double = 0
    @State private var screenType = ScreenType.main
    @State private var settingsToggle = SettingsToggle.off
    @State private var startButtonSpotlightAnimationAmount = 1.0
    
    @State private var changeColorOfLargeTitleOnMainScreen = false
    @Binding var numberOfRounds: Int
    @Binding var playButtonTitle: String
    @Binding var multiplicationTable: Int
    
    var isEndGame: Bool
    var finalScore: Int
    let multiplicationTableRange = 2...12
    let numberOfRoundRange = [5, 10, 20]
    
    var playAction: () -> Void
    
    func switchSettingsPanel() {
        settingsButtonSpinDegree += 360
        
        if settingsToggle == SettingsToggle.off {
            settingsToggle = SettingsToggle.on
        } else {
            settingsToggle = SettingsToggle.off
            showMenuOfNumberOfRoundSelection = false
            showMenuOfMultiplicationTableSelection = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("MULTIPLICATION\nGAME")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 35, weight: .bold))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), radius: 10, x: 0, y: 1)
                    .changeTextColor(Color(UIColor.hexStringToUIColor(hex: changeColorOfLargeTitleOnMainScreen ? "05a899" : "ffff00")))
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        , value: changeColorOfLargeTitleOnMainScreen
                    )
                    .onAppear {
                        withAnimation {
                            changeColorOfLargeTitleOnMainScreen = true
                        }
                    }

                if isEndGame {
                    Spacer()

                    Text("GameOver!")
                        .font(.system(size: 70))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)

                    Text("Final Score\n\(finalScore)/\(numberOfRounds)")
                        .font(.system(size: 50))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                MGStartButton(
                    action: {
                        withAnimation {
                            startButtonSpinDegree += 360

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                playAction()
                            }
                        }
                }, label: playButtonTitle
                    , fontSize: 40
                    , width: 300
                    , height: 100
                    , spotlightAnimationAmount: $startButtonSpotlightAnimationAmount
                    , spinDegreeWhenButtonTapped: startButtonSpinDegree
                )
                
                Spacer()
            }

            VStack {
                if settingsToggle == SettingsToggle.on {
                    ZStack {
                        Color(UIColor.hexStringToUIColor(hex: "05a899"))
                            .opacity(0.8)
                            .ignoresSafeArea()
                            .edgesIgnoringSafeArea(Edge.Set.all)

                        VStack {
                            Spacer()
                            MGSettingsPanel(
                                panelTitle: "SETTINGS",
                                multiplicationTableSettingTitle: "Multiplication table",
                                multiplicationTableOptionRange: Array(multiplicationTableRange),
                                selectedMultiplicationTable: $multiplicationTable,
                                showMenuOfMultiplicationTableSelection: $showMenuOfMultiplicationTableSelection,
                                numberOfRoundSettingTitle: "Number of rounds",
                                numberOfRoundOptionRange: numberOfRoundRange,
                                selectedNumberOfRound: $numberOfRounds,
                                showMenuOfNumberOfRoundSelection: $showMenuOfNumberOfRoundSelection
                            )
                        }
                        .offset(y: -50)
                    }
                    .gesture(
                        TapGesture(count: 1)
                            .onEnded({ _ in
                                withAnimation() {
                                    showMenuOfNumberOfRoundSelection = false
                                    showMenuOfMultiplicationTableSelection = false
                                }
                            })
                    )
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    withAnimation {
                        switchSettingsPanel()
                    }

                } label: {
                    ZStack {
                        Circle()
                            .fill(Material.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)

                        Image(systemName: settingsToggle == SettingsToggle.off ? "gearshape" : "xmark.circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: settingsToggle == SettingsToggle.off ? "05a899" : "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    }

                }
                .offset(y: -5)
                .rotation3DEffect(.degrees(settingsButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
            }
        }
        .transition(.move(edge: Edge.bottom))
        .animation(.easeOut(duration: 0.5), value: screenType)
    }
}
