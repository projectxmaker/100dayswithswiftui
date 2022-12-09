//
//  MainScreen.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @StateObject var vm = MainScreenViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("MULTIPLICATION\nGAME")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 35, weight: .bold))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), radius: 10, x: 0, y: 1)
                    .changeTextColor(Color(UIColor.hexStringToUIColor(hex: vm.changeColorOfLargeTitleOnMainScreen ? "05a899" : "ffff00")))
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        , value: vm.changeColorOfLargeTitleOnMainScreen
                    )
                    .onAppear {
                        withAnimation {
                            vm.changeColorOfLargeTitleOnMainScreen = true
                        }
                    }

                if contentVM.isEndGame {
                    Spacer()

                    Text("GameOver!")
                        .font(.system(size: 70))
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                        .fontWeight(.bold)
                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                        .multilineTextAlignment(.center)

                    Text("Final Score\n\(contentVM.finalScore)/\(contentVM.numberOfRounds)")
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
                            vm.startButtonSpinDegree += 360

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                contentVM.playGame()
                            }
                        }
                }, label: contentVM.playButtonTitle
                    , fontSize: 40
                    , width: 300
                    , height: 100
                    , spotlightAnimationAmount: $vm.startButtonSpotlightAnimationAmount
                    , spinDegreeWhenButtonTapped: vm.startButtonSpinDegree
                )
                
                Spacer()
            }

            VStack {
                if vm.settingsToggle == SettingsToggle.on {
                    MGSettingsPanel(
                        panelTitle: "SETTINGS",
                        multiplicationTableSettingTitle: "Multiplication table",
                        multiplicationTableOptionRange: Array(vm.multiplicationTableRange),
                        selectedMultiplicationTable: $contentVM.multiplicationTable,
                        showMenuOfMultiplicationTableSelection: $vm.showMenuOfMultiplicationTableSelection,
                        numberOfRoundSettingTitle: "Number of rounds",
                        numberOfRoundOptionRange: vm.numberOfRoundRange,
                        selectedNumberOfRound: $contentVM.numberOfRounds,
                        showMenuOfNumberOfRoundSelection: $vm.showMenuOfNumberOfRoundSelection
                    )
                }
            }
            
            VStack {
                
                Spacer()
                
                Button {
                    withAnimation {
                        vm.switchSettingsPanel()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Material.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)

                        Image(systemName: vm.settingsToggle == SettingsToggle.off ? "gearshape" : "xmark.circle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: vm.settingsToggle == SettingsToggle.off ? "05a899" : "ffff00")))
                            .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
                    }

                }
                .rotation3DEffect(.degrees(vm.settingsButtonSpinDegree), axis: (x: 1, y: 0, z: 0))
            }
        }
        .transition(.move(edge: Edge.bottom))
        .animation(.easeOut(duration: 0.5), value: contentVM.screenType)
    }
}

struct MainScreen_Preview: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(ContentViewModel())
    }
}
