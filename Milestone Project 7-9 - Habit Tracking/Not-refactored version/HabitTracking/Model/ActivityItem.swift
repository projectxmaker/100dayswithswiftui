//
//  Activity.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import Foundation

struct ActivityItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    var completionCount: Int = 0
    
    // MARK: - Extra Functions
    func getCompletionCountDescription(count: Int = -1) -> String {
        let countValue = count < 0 ? completionCount : count
        return "\(countValue) time\(countValue > 1 ? "s" : "")"
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
