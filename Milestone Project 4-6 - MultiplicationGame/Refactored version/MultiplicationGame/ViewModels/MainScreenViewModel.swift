//
//  MainScreenViewModel.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 12/9/22.
//

import Foundation

class MainScreenViewModel: ObservableObject {
    // MARK: - Published variables
    @Published var showMenuOfMultiplicationTableSelection = false
    @Published var showMenuOfNumberOfRoundSelection = false
    @Published var startButtonSpotlightAnimationAmount = 1.0
    @Published var settingsToggle = SettingsToggle.off
    
    // MARK: - Public variables
    @Published var settingsButtonSpinDegree: Double = 0
    @Published var startButtonSpinDegree: Double = 0
    @Published var changeColorOfLargeTitleOnMainScreen = false
    
    // MARK: - Contants
    let multiplicationTableRange = 2...12
    let numberOfRoundRange = [5, 10, 20]

    // MARK: - Functions
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
}
