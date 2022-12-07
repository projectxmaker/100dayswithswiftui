//
//  TimeToWakeUpSectionView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct TimeToWakeUpSectionView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        Section {
            Text("When do you want to wake up?")
                .font(.headline)
            
            DatePicker("Please enter a time", selection: $vm.wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .onChange(of: vm.wakeUp) { newValue in
                    vm.updateBedtime()
                }
        }
    }
}

struct TimeToWakeUpSectionView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ContentViewModel()
        
        var body: some View {
            Form {
                TimeToWakeUpSectionView()
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
