//
//  ContentView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ContentView: View {
    let locationFetcher = LocationFetcher()

    var body: some View {
        GeometryReader { geometry in
            ListView(geometry: geometry)
        }
        .task {
            self.locationFetcher.start()
        }
        .environmentObject(locationFetcher)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
