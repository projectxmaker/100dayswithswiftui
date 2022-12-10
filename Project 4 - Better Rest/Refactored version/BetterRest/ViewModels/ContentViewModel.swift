//
//  ContentViewModel.swift
//  BetterRest
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import Foundation
import CoreML
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var wakeUp = ContentViewModel.keys.defaultWakeTime
    @Published var sleepAmount = ContentViewModel.keys.defaultSleepAmount
    @Published var coffeeAmount = ContentViewModel.keys.defaultCoffeeAmount
    @Published var recommendedSleepingTime: Date?
    
    let tomorrow = Date.now.addingTimeInterval(86400)
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }
    
    // MARK: - Functions
    func calculateBedtime(wakeUp: Date? = ContentViewModel.keys.defaultWakeTime, sleepAmount: Double? = ContentViewModel.keys.defaultSleepAmount, coffeeAmount: Double? = Double(ContentViewModel.keys.defaultCoffeeAmount)) {
        
        guard let wakeUp = wakeUp,
              let sleepAmount = sleepAmount,
              let coffeeAmount = coffeeAmount
        else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            recommendedSleepingTime = wakeUp - prediction.actualSleep
        } catch {
            recommendedSleepingTime = nil
        }
    }
    
    // MARK: - Instance Methods
    
    func updateBedtime() {
        calculateBedtime(wakeUp: wakeUp, sleepAmount: sleepAmount, coffeeAmount: Double(coffeeAmount))
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
