//
//  ContentView.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 9/30/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = defaultSleepAmount
    @State private var coffeeAmount = defaultCoffeeAmount
    
    @State private var recommendedBedtime = calculateBedtime()
    
    let tomorrow = Date.now.addingTimeInterval(86400)
    
    // MARK: - Static variables / functions
    
    static var defaultSleepAmount = 8.0
    static var defaultCoffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    static func generateBedTimeMessage(title: String, message: String) -> String {
        return "\(title) \(message)"
    }
    
    static func calculateBedtime(wakeUp: Date? = defaultWakeTime, sleepAmount: Double? = defaultSleepAmount, coffeeAmount: Double? = Double(defaultCoffeeAmount)) -> String {
        
        var title = "Error:"
        var message = "Sorry, there was a problem calculating your bedtime."
        
        guard let wakeUp = wakeUp,
              let sleepAmount = sleepAmount,
              let coffeeAmount = coffeeAmount
        else {
            return generateBedTimeMessage(title: title, message: message)
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            title = "Your ideal bedtime is"
            message = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            // no
        }
        
        return generateBedTimeMessage(title: title, message: message)
    }
    
    // MARK: - Instance Methods
    
    func updateBedtime() {
        recommendedBedtime = ContentView.calculateBedtime(wakeUp: wakeUp, sleepAmount: sleepAmount, coffeeAmount: Double(coffeeAmount))
    }
    
    // MARK: - body var
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) { newValue in
                            updateBedtime()
                        }
                }

                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) { newValue in
                            updateBedtime()
                        }
                }
                
                Section {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1..<21) { eachOption in
                            Text("\(eachOption)")
                        }
                    }
                    .onChange(of: coffeeAmount) { newValue in
                        updateBedtime()
                    }
                }
                
                Section {
                    Text("Recommendation")
                        .font(.largeTitle)
                    Text("\(recommendedBedtime)")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
