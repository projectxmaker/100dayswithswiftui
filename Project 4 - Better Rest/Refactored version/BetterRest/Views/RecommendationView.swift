//
//  RecommendationView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct RecommendationView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        Section {
            Text("Recommendation")
                .font(.largeTitle)
            
            if let sleepingTime = vm.recommendedSleepingTime {
                Text("Your ideal bedtime is ") + Text(sleepingTime, formatter: vm.dateFormatter)
            } else {
                Text("Error: Sorry, there was a problem predicting your bedtime.")
            }
            
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ContentViewModel()
        
        var body: some View {
            Form {
                RecommendationView()
            }
            .task {
                vm.updateBedtime()
            }
            .environmentObject(vm)
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
