//
//  ContentViewModel.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 12/10/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var showingGrid = true
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
}
