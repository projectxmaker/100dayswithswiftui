//
//  ShowDetailsViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation
import SwiftUI

class ShowActivityDetailsViewModel: ObservableObject {
    private var activityManager = ActivityManager.shared
    
    @Published var selectedActivityItem: ActivityItem {
        didSet {
            activityManager.updateAnActivity(selectedActivityItem)
        }
    }
    
    var listVM: ShowActivityListViewModel
    
    init(selectedActivityItem: ActivityItem, listVM: ShowActivityListViewModel) {
        self.selectedActivityItem = selectedActivityItem
        self.listVM = listVM
    }
    
    // MARK - Extra Functions
    func increaseCompletionCount() {
        selectedActivityItem.increaseCompletionCount()
        listVM.loadActivities()
    }

    func decreaseCompletionCount() {
        selectedActivityItem.decreaseCompletionCount()
        listVM.loadActivities()
    }
    
    func getCompletionCountDescription() -> LocalizedStringKey {
        return selectedActivityItem.getCompletionCountDescription()
    }
}
