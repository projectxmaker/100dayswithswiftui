//
//  DesiredAmountOfSleepView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct DesiredAmountOfSleepView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        Section {
            Text("Desired amount of sleep")
                .font(.headline)
            
            Stepper("\(vm.sleepAmount.formatted()) hours", value: $vm.sleepAmount, in: 4...12, step: 0.25)
                .onChange(of: vm.sleepAmount) { newValue in
                    vm.updateBedtime()
                }
        }
    }
}

struct DesiredAmountOfSleepView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ContentViewModel()
        
        var body: some View {
            Form {
                DesiredAmountOfSleepView()
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
