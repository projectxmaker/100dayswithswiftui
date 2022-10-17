//
//  ShowDetailsViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation

class ShowActivityDetailsViewModel: ObservableObject {
    private var activityManager: ActivityManager
    
    var selectedActivityItem: ActivityItem {
        didSet {
            activityManager.updateAnActivity(selectedActivityItem)
        }
    }
    
    init(activityManager: ActivityManager, selectedActivityItem: ActivityItem) {
        self.activityManager = activityManager
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
