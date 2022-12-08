//
//  DailyCoffeeIntakeView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct DailyCoffeeIntakeView: View {
    @EnvironmentObject var vm: ContentViewModel
    
    var body: some View {
        Section {
            Text("Daily coffee intake")
                .font(.headline)
            
            Picker("^[\(vm.coffeeAmount) cup](inflect: true)", selection: $vm.coffeeAmount) {
                ForEach(1..<21, id: \.self) { eachOption in
                    Text("\(eachOption)")
                }
            }
            .onChange(of: vm.coffeeAmount) { newValue in
                vm.updateBedtime()
            }
        }
    }
}

struct DailyCoffeeIntakeView_Previews: PreviewProvider {
    struct SampleView: View {
        @StateObject var vm = ContentViewModel()
        
        var body: some View {
            Form {
                DailyCoffeeIntakeView()
            }
            .task {
                vm.updateBedtime()
            }
            .environmentObject(vm)
        }
    }
    
    static var previews: some View {
        SampleView()
            .environment(\.locale, Locale(identifier: "en_US"))
    }
}
