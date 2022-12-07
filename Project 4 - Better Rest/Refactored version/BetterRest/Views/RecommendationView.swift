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
            Text("\(vm.recommendedBedtime)")
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
