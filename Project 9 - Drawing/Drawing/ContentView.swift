//
//  ContentView.swift
//  Drawing
//
//  Created by Pham Anh Tuan on 10/13/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    ArrowView()
                } label: {
                    Text("Arrow")
                        .font(.largeTitle.bold())
                }
                
                NavigationLink {
                    ColorCyclingRetangleView()
                } label: {
                    Text("Color Cycling Retangle")
                        .font(.largeTitle.bold())
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
