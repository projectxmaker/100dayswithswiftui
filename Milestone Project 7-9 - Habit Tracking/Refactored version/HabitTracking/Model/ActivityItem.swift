//
//  Activity.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import Foundation
import SwiftUI

struct ActivityItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    var completionCount: Int = 0
    
    // MARK: - Extra Functions
    func getCompletionCountDescription(count: Int = -1) -> LocalizedStringKey {
        let countValue = count < 0 ? completionCount : count
        return LocalizedStringKey("\(countValue) time")
    }
    
    mutating func increaseCompletionCount() {
        completionCount += 1
    }

    mutating func decreaseCompletionCount() {
        completionCount = completionCount > 1 ? completionCount - 1 : 0
    }
}

extension ActivityItem: Equatable {
    public static func ==(lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ActivityItem {
    static var sampleActivityItems = [
        ActivityItem(title: "Run", description: "Daily"),
        ActivityItem(title: "Hop", description: "Hourly"),
        ActivityItem(title: "Jump", description: "At night")
    ]
}
