//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicationTable = 2
    @State private var numberOfRounds = 5
    @State private var settingsToggle = true
    
    // MARK: - Extra Funcs
    func play() {
        print("play")
    }
    
    func switchSettingsPanel() {
        settingsToggle.toggle()
    }
    
    var body: some View {
        NavigationView {
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
                        .frame(height: settingsToggle ? 0 : 180)
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        switchSettingsPanel()
                    } label: {
                        Text(settingsToggle ? "Settings" : "Close")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
