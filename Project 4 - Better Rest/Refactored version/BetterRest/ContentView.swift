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
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $vm.wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: vm.wakeUp) { newValue in
                            vm.updateBedtime()
                        }
                }

                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(vm.sleepAmount.formatted()) hours", value: $vm.sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: vm.sleepAmount) { newValue in
                            vm.updateBedtime()
                        }
                }
                
                Section {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker(vm.coffeeAmount == 1 ? "1 cup" : "\(vm.coffeeAmount) cups", selection: $vm.coffeeAmount) {
                        ForEach(1..<21, id: \.self) { eachOption in
                            Text("\(eachOption)")
                        }
                    }
                    .onChange(of: vm.coffeeAmount) { newValue in
                        vm.updateBedtime()
                    }
                }
                
                Section {
                    Text("Recommendation")
                        .font(.largeTitle)
                    Text("\(vm.recommendedBedtime)")
                }
            }
            .navigationTitle("BetterRest")
        }
        .task {
            vm.updateBedtime()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
