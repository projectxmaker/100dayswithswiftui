//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/3/22.
//

import SwiftUI
import UIKit

enum ScreenType {
    case main
    case play
    case result
}

enum SettingsToggle {
    case on
    case off
}

struct ContentView: View {
    @State private var multiplicationTable = 2
    @State private var numberOfRounds = 5
    @State private var settingsToggle = SettingsToggle.off
    @State private var screenType = ScreenType.main
    
    // MARK: - Extra Funcs
    func play() {
        screenType = ScreenType.play
    }
    
    func quitPlayingGame() {
        screenType = ScreenType.main
    }

    func switchSettingsPanel() {
        if settingsToggle == SettingsToggle.off {
            settingsToggle = SettingsToggle.on
        } else {
            settingsToggle = SettingsToggle.off
        }
    }
    
    func getMainScreen() -> some View {
        VStack (spacing: 20) {
            ZStack {
                Button {
                    play()
                } label: {
                    Text("PLAY")
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                .frame(width: 200, height: 100)
                .background(.blue)
                .clipShape(Capsule())
                
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    if settingsToggle == SettingsToggle.on {
                        Form {
                            Section("Settings") {
                                Picker("Multiplication Table", selection: $multiplicationTable) {
                                    ForEach(2...12, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                Picker("Number Of Round", selection: $numberOfRounds) {
                                    ForEach([5, 10, 20], id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                            }
                        }
                        .frame(height: settingsToggle == SettingsToggle.off ? 0 : 180)
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        switchSettingsPanel()
                    } label: {
                        Text(settingsToggle == SettingsToggle.off ? "Settings" : "Close")
                            .foregroundColor(.blue)
                    }
                }
            }
        }

        .ignoresSafeArea()
    }
    
    func getPlayScreen() -> some View {
        VStack (spacing: 20) {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "37B6F6")), location: 0),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "37B6F6")), location: 0.2),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f9e104")), location: 0.4),
                    Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                ], startPoint: .top, endPoint: .bottom)
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    Text("12 x 12")
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        ForEach(0..<4, id: \.self) { colIndex in
                            Button {
                                play()
                            } label: {
                                Text("\(colIndex)")
                            }
                            .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(width: 300, height: 100)
                            .background(Color(UIColor.hexStringToUIColor(hex: "37B6F6")))
                            .clipShape(Capsule())
                        }
                    }
                    Spacer()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            quitPlayingGame()
                        } label: {
                            Text("Quit")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func getResultScreen() -> some View {
        ZStack {
            Button("Hello") {
            }
        }
    }
    
    var body: some View {
        NavigationView {
            switch screenType {
            case .main:
                getMainScreen()
            case .play:
                getPlayScreen()
            case .result:
                getResultScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
