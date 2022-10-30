//
//  ContentView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ListView(geometry: geometry)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
