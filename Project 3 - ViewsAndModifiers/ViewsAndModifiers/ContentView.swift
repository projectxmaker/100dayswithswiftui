//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Pham Anh Tuan on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    @State private var choseOne = 0
    @State private var something = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            Section {
                Text("Text WITHOUT Large Blue Font Modifier")
                Text("Text WITH Large Blue Font Modifier")
                    .largeBlueFont()
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
    }
}

extension View {
    func largeBlueFont() -> some View {
        modifier(LargeBlueFont())
    }
}
