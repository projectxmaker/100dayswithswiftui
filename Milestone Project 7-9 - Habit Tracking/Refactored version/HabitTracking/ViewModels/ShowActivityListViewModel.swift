//
//  ShowActivityListViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/17/22.
//

import Foundation

class ShowActivityListViewModel: ObservableObject {
    @Published var showActivityCreationView = false
    @Published var showDeletionAlert = false
    @Published var deletedItem: ActivityItem?
    
    private var activityManager = ActivityManager.shared
    
    func getActivityManager() -> ActivityManager {
        return activityManager
    }
    
    func getActivities() -> [ActivityItem] {
        activityManager.getActivities()
    }
    
    func deleteActivityById(_ id: UUID) {
        activityManager.deleteActivityById(id)
    }
}
