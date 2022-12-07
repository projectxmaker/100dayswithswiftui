//
//  ContentView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 9/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    // MARK: - body var
    var body: some View {
        NavigationView {
            Form {
                TimeToWakeUpSectionView()
                DesiredAmountOfSleepView()
                DailyCoffeeIntakeView()
                RecommendationView()
            }
            .navigationTitle("BetterRest")
        }
        .task {
            vm.updateBedtime()
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
