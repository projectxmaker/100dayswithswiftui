//
//  ShowDetailsViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation

class ShowActivityDetailsViewModel: ObservableObject {
    var activities: Activities
    var selectedActivityItem: ActivityItem {
        didSet {
            activities.updateAnActivity(selectedActivityItem)
            print("updated \(selectedActivityItem)")
        }
    }
    
    init(activities: Activities, selectedActivityItem: ActivityItem) {
        self.activities = activities
        self.selectedActivityItem = selectedActivityItem
    }
    
    // MARK - Extra Functions
    func increaseCompletionCount() {
        selectedActivityItem.increaseCompletionCount()
    }

    func decreaseCompletionCount() {
        selectedActivityItem.decreaseCompletionCount()
    }
    
    func getCompletionCountDescription() -> String {
        return selectedActivityItem.getCompletionCountDescription()
    }
}
