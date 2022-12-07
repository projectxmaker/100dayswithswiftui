//
//  ContentViewModel.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation
import CoreML

@MainActor
class ContentViewModel: ObservableObject {
    @Published var wakeUp = ContentViewModel.keys.defaultWakeTime
    @Published var sleepAmount = ContentViewModel.keys.defaultSleepAmount
    @Published var coffeeAmount = ContentViewModel.keys.defaultCoffeeAmount
    
    @Published var recommendedBedtime: String = ""
    
    let tomorrow = Date.now.addingTimeInterval(86400)
    
    // MARK: - Functions
    func generateBedTimeMessage(title: String, message: String) -> String {
        return "\(title) \(message)"
    }
    
    func calculateBedtime(wakeUp: Date? = ContentViewModel.keys.defaultWakeTime, sleepAmount: Double? = ContentViewModel.keys.defaultSleepAmount, coffeeAmount: Double? = Double(ContentViewModel.keys.defaultCoffeeAmount)) -> String {
        
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
        recommendedBedtime = calculateBedtime(wakeUp: wakeUp, sleepAmount: sleepAmount, coffeeAmount: Double(coffeeAmount))
    }
    
}

extension ContentViewModel {
    struct keys {
        static let defaultSleepAmount = 8.0
        static let defaultCoffeeAmount = 1
        static var defaultWakeTime: Date {
            var components = DateComponents()
            components.hour = 7
            components.minute = 0
            return Calendar.current.date(from: components) ?? Date.now
        }
    }
}
