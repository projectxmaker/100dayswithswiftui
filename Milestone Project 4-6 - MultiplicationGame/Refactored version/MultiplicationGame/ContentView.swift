//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/3/22.
//

import SwiftUI
import UIKit

enum SettingsToggle {
    case on
    case off
}

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    // MARK: - body
    var body: some View {
        VStack (spacing: 20) {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.17),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "05a899")), location: 0.75),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 1)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

                switch vm.screenType {
                case .main:
                    MainScreen()
                case .play:
                    PlayScreen(
                        numberOfRounds: vm.numberOfRounds,
                        multiplicationTable: vm.multiplicationTable,
                        runAfterGameIsOver: vm.runAfterGameIsOver(_:),
                        runQuitGame: vm.runAfterQuittingGame)
                }
            }
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
