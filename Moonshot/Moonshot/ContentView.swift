//
//  ContentView.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/11/22.
//

import SwiftUI


struct ContentView: View {
    let astronauts = Bundle.main.decode("astronauts.json")
    
    var body: some View {
        Text("\(astronauts.count)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
