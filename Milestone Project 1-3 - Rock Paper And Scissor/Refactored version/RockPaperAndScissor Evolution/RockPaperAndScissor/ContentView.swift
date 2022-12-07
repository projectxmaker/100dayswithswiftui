//
//  ContentView.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: .indigo, location: 0),
                    Gradient.Stop(color: .yellow, location: 0.5),
                    Gradient.Stop(color: .indigo, location: 1)
                ], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
                
                VStack {
                    Text("Round: \(vm.round)")
                        .font(.custom(ContentView.keys.fontName, size: 30))
                        .foregroundColor(.blue)
                        .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                        
                    VStack (spacing: 10) {
                        CircleTextView(
                            item: vm.botChoice,
                            backgroundColors: [.white, .indigo, .yellow],
                            shadowColor: .yellow
                        )
                        
                        Text(vm.resultStatus.rawValue)
                            .font(.custom(ContentView.keys.fontName, size: 60))
                            .foregroundColor(.blue)
                            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        ForEach($vm.items, id: \.self) { item in
                            CircleButtonView(
                                item: item.wrappedValue,
                                backgroundColors: [.gray, .blue, .white],
                                shadowColor: .yellow)
                            .disabled(vm.deactivateButtons)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .alert("GameOver", isPresented: $vm.showAlert) {
            Button("Restart") {
                // restart game
                vm.restartGame()
            }
        } message: {
            Text("Final Score is \(vm.score)!\n")
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
