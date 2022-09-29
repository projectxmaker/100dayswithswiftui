//
//  ContentView.swift
//  RockPaperAndScissor
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import SwiftUI

enum ResultStatus: String {
    case botWin = "Win"
    case botLose = "Lose"
}

struct ContentView: View {
    @State private var items: [String] = [
        "✊",
        "🖐",
        "✌️",
    ]
    @State private var userChoice = ""
    
    @State private var itemOfBot: Int = 0
    @State private var resultStatus = ResultStatus.botWin
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text(items[itemOfBot])
                    Text(resultStatus.rawValue)
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                userChoice = item
                            } label: {
                                Text(item)
                                    .font(.system(size: 100))
                                    .frame(width: 160, height: 160)
                                    .background(RadialGradient(colors: [.red, .yellow, .blue], center: .center, startRadius: 20, endRadius: 100))
                                    .clipShape(Capsule())
                                    .shadow(color: .white, radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
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
