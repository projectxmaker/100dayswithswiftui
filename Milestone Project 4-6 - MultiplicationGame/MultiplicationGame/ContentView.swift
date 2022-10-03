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
    
    // MARK: - Extra Funcs
    func play() {
        print("play")
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                VStack {
                    Spacer()
                    
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
                    
                    Spacer()
                    
                    Form {
                        Section {
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
                        } header: {
                            Text("Settings")
                        }
                    }
                    .frame(height: 180)
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
